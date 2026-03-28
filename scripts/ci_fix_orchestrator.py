import sys
import os
import subprocess
import json
import shlex
import secrets
import urllib.request

# Tools 디렉토리를 경로에 추가하여 nightwatch_config 등을 가져올 수 있게 합니다.
sys.path.append(os.getcwd())
sys.path.append(os.path.join(os.getcwd(), 'Tools'))

try:
    from nightwatch_config import patch_openclaw_config, setup_docker_symlinks, run_command
except ImportError:
    # 💥 모듈 로드 실패 시 디버깅 정보 출력 및 폴백 로직 강화
    print("⚠️ Warning: nightwatch_config not found. Using fallback functions.")
    print(f"DEBUG: Current CWD is {os.getcwd()}")
    print(f"DEBUG: sys.path is {sys.path}")

    def patch_openclaw_config(gemini_api_key, tag, openclaw_gateway_token=None):
        return False

    def setup_docker_symlinks():
        pass

    def run_command(command, shell=True, env=None):
        res = subprocess.run(command, shell=shell, capture_output=True, text=True, env=env)
        return res.returncode, res.stdout

# ==============================================================================
# 설정 (Configuration)
# ==============================================================================
MAX_RETRIES = 3
FIX_COMMIT_TAG = "fix(ci): self-healing fix for CI failure"
AGENT_ID = "ci-fixer"

def send_discord_message(content):
    """Discord 웹훅을 통해 메시지를 전송합니다."""
    webhook_url = os.getenv("DISCORD_WEBHOOK_URL")
    if not webhook_url:
        print("⚠️ DISCORD_WEBHOOK_URL 환경 변수가 설정되지 않아 알림을 보낼 수 없습니다.")
        return

    print("📡 Sending Discord notification...")
    data = {"content": content}
    payload = json.dumps(data).encode("utf-8")

    req = urllib.request.Request(
        webhook_url,
        data=payload,
        headers={
            "Content-Type": "application/json",
            "User-Agent": "NightWatch-CI-Fixer/1.0"
        },
        method="POST"
    )
    try:
        with urllib.request.urlopen(req) as response:
            print(f"✅ Discord notification sent successfully (Status: {response.status})")
    except Exception as e:
        print(f"❌ Discord 알림 전송 실패: {e}")
        try:
            subprocess.run([
                "curl", "-X", "POST", "-H", "Content-Type: application/json",
                "-d", json.dumps(data), webhook_url
            ], check=True, capture_output=True)
            print("✅ Discord notification sent successfully via curl fallback.")
        except Exception as curl_e:
            print(f"❌ Curl fallback failed: {curl_e}")

def run_git(args):
    """Git 명령어를 실행하고 결과를 반환합니다."""
    try:
        result = subprocess.run(
            ["git"] + args,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"❌ Git error ({args}): {e.stderr}")
        return ""

def check_retry_limit():
    """커밋 로그를 확인하여 셀프 힐링 시도 횟수가 초과되었는지 확인합니다."""
    logs = run_git(["log", "-n", "10", "--pretty=format:%s"])
    if not logs:
        return 0

    count = logs.count(FIX_COMMIT_TAG)
    print(f"🔍 Current self-healing attempts in this branch: {count}/{MAX_RETRIES}")
    return count

def call_openclaw_agent(log_content):
    """OpenClaw 에이전트를 호출하여 2단계(Plan -> Work)로 수정 작업을 수행합니다."""
    print(f"🤖 Starting 2-phase self-healing with {AGENT_ID} agent...")

    gemini_api_key = os.getenv('GEMINI_API_KEY')
    if not gemini_api_key:
        print("❌ GEMINI_API_KEY 환경 변수가 설정되지 않았습니다.")
        return False

    openclaw_gateway_token = secrets.token_hex(24)
    setup_docker_symlinks()

    # --- Phase 1: Planning (using Frontier Model/Gemini) ---
    print("\n--- Phase 1: Planning (PLANNER: Gemini) ---")
    patch_openclaw_config(gemini_api_key, "PLANNER", openclaw_gateway_token)

    plan_prompt = (
        "The CI pipeline has failed. Below is the relevant log content. "
        "Please analyze the error and create a detailed, rich, and practical implementation plan in `/workspace/plan.md`. "
        "Explain exactly how to fix the issue, which files to modify, and what logic to change. "
        "Do not modify any other files yet. Just write the comprehensive plan to `plan.md`.\n\n"
        "--- CI FAILURE LOG ---\n"
        f"{log_content}\n"
        "--- END OF LOG ---\n"
    )

    if os.getenv("GITHUB_ACTIONS"):
        # 기존에 남아있을 수 있는 컨테이너 및 네트워크 정리 (충돌 방지)
        print("🧹 Cleaning up old CI gateway containers...")
        run_command("docker compose -f docker-compose.nightwatch.yml down -v --remove-orphans > /dev/null 2>&1")

        gw_cmd = f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json OPENCLAW_STATE_DIR=/workspace/.openclaw_config docker compose -f docker-compose.nightwatch.yml up --build -d openclaw-gateway"
        rc, _ = run_command(gw_cmd)
        if rc != 0:
            print("❌ Failed to start CI OpenClaw gateway.")
            return False
        run_command("sleep 5")

        agent_plan_cmd = [
            "docker", "compose", "-f", "docker-compose.nightwatch.yml", "run", "--rm", "-T",
            "-e", f"GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
            "-e", "OPENCLAW_ACCEPT_RISK=true",
            "-e", "OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1",
            "-e", "OPENCLAW_GATEWAY_URL=ws://openclaw-gateway:18789",
            "-e", f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
            "-e", "OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
            "-e", "OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
            "nightwatch-agent",
            "openclaw", "agent", "--agent", AGENT_ID, "--message", shlex.quote(plan_prompt)
        ]

        try:
            subprocess.run(agent_plan_cmd, check=True)
            print("✅ Planning phase completed. Plan written to plan.md.")
        except subprocess.CalledProcessError as e:
            print(f"❌ Planning phase failed: {e}")
            run_command("docker compose -f docker-compose.nightwatch.yml stop openclaw-gateway")
            run_command("sudo chown -R $(id -u):$(id -g) .")
            return False

        # --- Phase 2: Working (using Local LLM) ---
        print("\n--- Phase 2: Working (WORKER: Local Qwen2.5-Coder) ---")
        patch_openclaw_config(gemini_api_key, "WORKER", openclaw_gateway_token)

        work_prompt = (
            "You are now running on a local model optimized for coding. "
            "Please read the detailed implementation plan in `/workspace/plan.md` and execute it precisely. "
            "Modify the necessary files to fix the CI failure according to the plan. "
            "If you detect linting issues, you can use `autopep8 --in-place <file>`."
        )

        agent_work_cmd = [
            "docker", "compose", "-f", "docker-compose.nightwatch.yml", "run", "--rm", "-T",
            "-e", f"GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
            "-e", "OPENCLAW_ACCEPT_RISK=true",
            "-e", "OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1",
            "-e", "OPENCLAW_GATEWAY_URL=ws://openclaw-gateway:18789",
            "-e", f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
            "-e", "OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
            "-e", "OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
            "nightwatch-agent",
            "openclaw", "agent", "--agent", AGENT_ID, "--message", shlex.quote(work_prompt)
        ]

        try:
            subprocess.run(agent_work_cmd, check=True)
            print("✅ Working phase completed.")
            run_command("docker compose -f docker-compose.nightwatch.yml stop openclaw-gateway")
            run_command("sudo chown -R $(id -u):$(id -g) .")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Working phase failed: {e}")
            run_command("docker compose -f docker-compose.nightwatch.yml stop openclaw-gateway")
            run_command("sudo chown -R $(id -u):$(id -g) .")
            return False
    else:
        print("ℹ️ Local environment detected. Skipping actual agent call.")
        return True


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 ci_fix_orchestrator.py <log_file>")
        sys.exit(1)

    log_file = sys.argv[1]
    if not os.path.exists(log_file):
        print(f"Error: Log file {log_file} not found.")
        sys.exit(1)

    # 1. 시도 횟수 체크
    retry_count = check_retry_limit()
    if retry_count >= MAX_RETRIES:
        msg = f"🚨 **[Limit Reached]** 자율 수정 시도 횟수({MAX_RETRIES}회)를 초과했습니다. 인간의 개입이 필요합니다."
        print(msg)
        send_discord_message(msg)
        sys.exit(0)

    # 2. 로그 파일 읽기
    with open(log_file, 'r') as f:
        log_content = f.read()
    
    if not log_content.strip() or "로그 캡처 실패" in log_content:
        print("⚠️ 실패 로그가 비어있거나 캡처에 실패했습니다.")
    
    lines = log_content.splitlines()[-150:]
    relevant_log = "\n".join(lines)
    
    print(f"--- Analyzing CI Failure Log: {log_file} (Last 150 lines) ---")
    print(relevant_log)
    print("------------------------------------------")

    # 2.5 자동 스타일 수정 (Linting Fix)
    if "flake8" in log_content.lower() or "pep8" in log_content.lower() or "test_lint.py" in log_content:
        print("💡 Linting/Style error detected. Running autopep8 for pre-fixing...")
        try:
            # 전체 코드베이스에 대해 autopep8 실행
            subprocess.run([
                "autopep8", "--in-place", "--recursive", ".",
                "--exclude", ".git,__pycache__,.venv", "--max-line-length", "120"
            ], check=True)
            print("✅ autopep8 execution completed.")
        except Exception as e:
            print(f"⚠️ autopep8 execution failed: {e}")

    # 3. 에이전트 호출
    success = call_openclaw_agent(relevant_log)
    if not success:
        send_discord_message("🚨 **NightWatch 자율 수정 중 에러 발생:** 에이전트 실행에 실패했습니다.")
        sys.exit(1)

    # 4. 변경 사항 커밋 및 푸시
    print(f"\n🚀 [Self-Healing] Checking for changes...")
    
    # 💥 중요: 불필요한 바이너리나 라이선스 파일이 같이 올라가지 않도록
    # 수정된 파이썬 파일들만 선별적으로 스테이징하도록 개선할 수 있으나,
    # 일단은 전체 add 후 원치 않는 디렉토리를 명시적으로 제외합니다.
    run_git(["add", "."])
    run_git(["reset", "typst*"]) # typst 관련 임시 디렉토리 제외
    
    status = run_git(["status", "--porcelain"])
    if not status:
        print("ℹ️ No changes detected by the agent.")
        send_discord_message("🔍 **NightWatch 분석 완료:** 에러를 분석했으나 자동 수정할 사항을 찾지 못했습니다.")
        sys.exit(0)

    print("📝 Changes detected! Committing fix...")
    run_git(["config", "user.name", "NightWatch Bot"])
    run_git(["config", "user.email", "nightwatch@kimpossible-ty"])
    
    run_git(["commit", "-m", FIX_COMMIT_TAG])
    
    branch = os.getenv("GITHUB_HEAD_REF") or os.getenv("GITHUB_REF_NAME") or run_git(["branch", "--show-current"])
    print(f"📤 Pushing fix to branch: {branch}...")
    
    if os.getenv("GITHUB_ACTIONS"):
        if branch:
            run_git(["push", "origin", f"HEAD:{branch}"])
            print("✅ 수정 사항이 푸시되었습니다.")
            send_discord_message(f"✅ **NightWatch 자율 수정 성공!**\n→ 내용: 에러를 진단하고 코드를 수정하여 `{branch}` 브랜치에 푸시했습니다.\n→ 시도 횟수: {retry_count + 1}/{MAX_RETRIES}")
        else:
            send_discord_message("❌ **NightWatch 푸시 실패:** 브랜치 이름을 결정할 수 없습니다.")
    else:
        print(f"ℹ️ 로컬 환경이므로 푸시를 스킵합니다.")

if __name__ == "__main__":
    main()
