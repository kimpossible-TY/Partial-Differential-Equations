import sys
import os
import subprocess
import json
import shlex
import secrets
import urllib.request

sys.path.append(os.getcwd())
sys.path.append(os.path.join(os.getcwd(), 'Tools'))

try:
    from nightwatch_config import patch_openclaw_config, setup_docker_symlinks, run_command
except ImportError:
    print("⚠️ Warning: nightwatch_config not found. Using fallback functions.")
    
    def patch_openclaw_config(gemini_api_key, tag, openclaw_gateway_token=None, gateway_port=18790):
        return False

    def setup_docker_symlinks():
        pass

    def run_command(command, shell=True, env=None):
        res = subprocess.run(command, shell=shell, capture_output=True, text=True, env=env)
        return res.returncode, res.stdout

MAX_RETRIES = 3
FIX_COMMIT_TAG = "fix(ci): self-healing fix for CI failure"
AGENT_ID = "ci-fixer"
# 동시성 격리를 위한 고유 프로젝트 및 포트 할당
PROJECT_ID = f"ci-fix-{secrets.token_hex(4)}"
GATEWAY_PORT = 18790

def send_discord_message(content):
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
        headers={"Content-Type": "application/json", "User-Agent": "NightWatch-CI-Fixer/1.0"},
        method="POST"
    )
    try:
        with urllib.request.urlopen(req) as response:
            print(f"✅ Discord notification sent (Status: {response.status})")
    except Exception as e:
        print(f"❌ Discord 알림 전송 실패: {e}")

def run_git(args):
    try:
        result = subprocess.run(["git"] + args, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"❌ Git error ({args}): {e.stderr}")
        return ""

def check_retry_limit():
    logs = run_git(["log", "-n", "10", "--pretty=format:%s"])
    if not logs:
        return 0
    count = logs.count(FIX_COMMIT_TAG)
    print(f"🔍 Current self-healing attempts: {count}/{MAX_RETRIES}")
    return count

def call_openclaw_agent(log_content):
    print(f"🤖 Starting 2-phase self-healing with {AGENT_ID} agent (Project: {PROJECT_ID})...")

    gemini_api_key = os.getenv('GEMINI_API_KEY')
    if not gemini_api_key:
        print("❌ GEMINI_API_KEY 환경 변수가 설정되지 않았습니다.")
        return False

    openclaw_gateway_token = secrets.token_hex(24)
    setup_docker_symlinks()

    print("\n--- Phase 1: Planning (PLANNER: Gemini) ---")
    patch_openclaw_config(gemini_api_key, "PLANNER", openclaw_gateway_token, GATEWAY_PORT)

    plan_prompt = (
        "The CI pipeline has failed. Below is the relevant log content. "
        "Create a detailed, practical implementation plan in `/workspace/plan.md`. "
        "Explain exactly how to fix the issue, files to modify, and logic to change. "
        "Do not modify any other files yet.\n\n"
        f"--- CI FAILURE LOG ---\n{log_content}\n--- END OF LOG ---\n"
    )

    if os.getenv("GITHUB_ACTIONS"):
        print("🧹 Cleaning up old CI gateway containers...")
        # 고유 프로젝트명 지정으로 다른 CI 컨테이너 건드리지 않음
        run_command(f"docker compose -p {PROJECT_ID} down -v --remove-orphans > /dev/null 2>&1")

        gw_cmd = (
            f"OPENCLAW_GATEWAY_PORT={GATEWAY_PORT} "
            f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} "
            f"OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json "
            f"OPENCLAW_STATE_DIR=/workspace/.openclaw_config "
            f"docker compose -p {PROJECT_ID} up --build -d openclaw-gateway"
        )
        rc, _ = run_command(gw_cmd)
        if rc != 0:
            print("❌ Failed to start CI OpenClaw gateway.")
            return False
        run_command("sleep 5")

        agent_plan_cmd = [
            "docker", "compose", "-p", PROJECT_ID, "run", "--rm", "-T",
            "-e", f"GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
            "-e", "OPENCLAW_ACCEPT_RISK=true",
            "-e", "OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1",
            "-e", f"OPENCLAW_GATEWAY_URL=ws://127.0.0.1:{GATEWAY_PORT}",
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
            run_command(f"docker compose -p {PROJECT_ID} stop openclaw-gateway")
            return False

        print("\n--- Phase 2: Working (WORKER: Local Qwen2.5-Coder) ---")
        patch_openclaw_config(gemini_api_key, "WORKER", openclaw_gateway_token, GATEWAY_PORT)

        work_prompt = (
            "You are now running on a local model optimized for coding. "
            "Execute the plan in `/workspace/plan.md`. "
            "Modify the necessary files to fix the CI failure."
        )

        agent_work_cmd = [
            "docker", "compose", "-p", PROJECT_ID, "run", "--rm", "-T",
            "-e", f"GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
            "-e", "OPENCLAW_ACCEPT_RISK=true",
            "-e", "OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1",
            "-e", f"OPENCLAW_GATEWAY_URL=ws://127.0.0.1:{GATEWAY_PORT}",
            "-e", f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
            "-e", "OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
            "-e", "OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
            "nightwatch-agent",
            "openclaw", "agent", "--agent", AGENT_ID, "--message", shlex.quote(work_prompt)
        ]

        try:
            subprocess.run(agent_work_cmd, check=True)
            print("✅ Working phase completed.")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Working phase failed: {e}")
            return False
        finally:
            run_command(f"docker compose -p {PROJECT_ID} down -v")
            run_command("sudo chown -R $(id -u):$(id -g) .")
    else:
        print("ℹ️ Local environment detected. Skipping actual agent call.")
        return True

def main():
    if len(sys.argv) < 2:
        sys.exit(1)

    log_file = sys.argv[1]
    retry_count = check_retry_limit()
    if retry_count >= MAX_RETRIES:
        msg = f"🚨 **[Limit Reached]** 자율 수정 시도 횟수({MAX_RETRIES}회) 초과."
        send_discord_message(msg)
        sys.exit(0)

    with open(log_file, 'r') as f:
        log_content = f.read()
    
    lines = log_content.splitlines()[-150:]
    relevant_log = "\n".join(lines)

    if "flake8" in log_content.lower() or "pep8" in log_content.lower():
        subprocess.run(["autopep8", "--in-place", "--recursive", ".", "--exclude", ".git,__pycache__,.venv", "--max-line-length", "120"])

    success = call_openclaw_agent(relevant_log)
    if not success:
        send_discord_message("🚨 **NightWatch 자율 수정 중 에러 발생**")
        sys.exit(1)

    run_git(["add", "."])
    run_git(["reset", "typst*"])
    status = run_git(["status", "--porcelain"])
    
    if not status:
        send_discord_message("🔍 **분석 완료:** 수정할 사항 없음.")
        sys.exit(0)

    run_git(["config", "user.name", "NightWatch Bot"])
    run_git(["config", "user.email", "nightwatch@kimpossible-ty"])
    run_git(["commit", "-m", FIX_COMMIT_TAG])
    
    branch = os.getenv("GITHUB_HEAD_REF") or os.getenv("GITHUB_REF_NAME") or run_git(["branch", "--show-current"])
    if os.getenv("GITHUB_ACTIONS") and branch:
        run_git(["push", "origin", f"HEAD:{branch}"])
        send_discord_message(f"✅ **수정 성공!** 브랜치: `{branch}` ({retry_count + 1}/{MAX_RETRIES})")

if __name__ == "__main__":
    main()

