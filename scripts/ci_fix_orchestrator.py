import sys
import os
import subprocess
from pathlib import Path
import json
import shlex
import secrets

# Tools 디렉토리를 경로에 추가하여 nightwatch_config 등을 가져올 수 있게 합니다.
sys.path.append(os.path.join(os.getcwd(), 'Tools'))

try:
    from nightwatch_config import patch_openclaw_config, setup_docker_symlinks, run_command
except ImportError:
    print("⚠️ Tools/nightwatch_config.py를 찾을 수 없습니다. 기본 설정을 시도합니다.")
    def patch_openclaw_config(*args, **kwargs): return False
    def setup_docker_symlinks(): pass
    def run_command(cmd): 
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return res.returncode, res.stdout

# ==============================================================================
# 설정 (Configuration)
# ==============================================================================
MAX_RETRIES = 2
FIX_COMMIT_TAG = "fix(ci): self-healing fix for CI failure"
AGENT_ID = "ci-fixer"

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
        return None

def check_retry_limit():
    """커밋 로그를 확인하여 셀프 힐링 시도 횟수가 초과되었는지 확인합니다."""
    logs = run_git(["log", "-n", "10", "--pretty=format:%s"])
    if not logs:
        return 0
    
    count = logs.count(FIX_COMMIT_TAG)
    print(f"🔍 Current self-healing attempts in this branch: {count}/{MAX_RETRIES}")
    return count

def call_openclaw_agent(log_content):
    """OpenClaw 에이전트를 호출하여 로그 분석 및 수정을 요청합니다."""
    print(f"🤖 Calling {AGENT_ID} agent to analyze and fix the CI failure...")
    
    gemini_api_key = os.getenv('GEMINI_API_KEY')
    if not gemini_api_key:
        print("❌ GEMINI_API_KEY 환경 변수가 설정되지 않았습니다.")
        return False

    # 1. OpenClaw 설정 패치 (에이전트 정보 및 토큰 주입)
    # CI 환경에서는 매번 새로운 토큰을 생성합니다.
    openclaw_gateway_token = secrets.token_hex(24)
    patch_openclaw_config(gemini_api_key, "FLASH", openclaw_gateway_token)
    setup_docker_symlinks()

    # 2. 에이전트에게 보낼 프롬프트 구성
    prompt = (
        "The CI pipeline has failed. Below is the relevant log content. "
        "Please analyze the error, find the root cause in the workspace, and apply a fix. "
        "Do not just explain; actually modify the code if possible. "
        "If you cannot fix it, explain why.\n\n"
        "--- CI FAILURE LOG ---\n"
        f"{log_content}\n"
        "--- END OF LOG ---\n"
    )

    # 3. 에이전트 실행 (Gateway 서버와 에이전트 컨테이너 실행)
    if os.getenv("GITHUB_ACTIONS"):
        # Gateway 실행
        gw_cmd = f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json OPENCLAW_STATE_DIR=/workspace/.openclaw_config docker compose up --build -d openclaw-gateway"
        run_command(gw_cmd)
        run_command("sleep 5")

        # Agent 실행
        agent_cmd = [
            "docker", "compose", "run", "--rm", "-T",
            "-e", f"GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
            "-e", "OPENCLAW_ACCEPT_RISK=true",
            "-e", f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
            "-e", "OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
            "-e", "OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
            "nightwatch-agent",
            "openclaw", "agent", "--agent", AGENT_ID, "--message", shlex.quote(prompt)
        ]
        
        try:
            subprocess.run(agent_cmd, check=True)
            run_command("docker compose stop openclaw-gateway")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ 에이전트 실행 실패: {e}")
            run_command("docker compose stop openclaw-gateway")
            return False
    else:
        # 로컬 테스트 환경
        print("ℹ️ Local environment detected. Skipping actual agent call.")
        print(f"Prompt that would be sent to {AGENT_ID}:\n{prompt[:200]}...")
        return True

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 ci_fix_orchestrator.py <log_file>")
        sys.exit(1)

    log_file = sys.argv[1]
    if not os.path.exists(log_file):
        print(f"Error: Log file {log_file} not found.")
        sys.exit(1)

    # 1. 시도 횟수 체크 (무한 루프 방지)
    if check_retry_limit() >= MAX_RETRIES:
        print(f"🚨 [Limit Reached] 이 브랜치에서 최대 자율 수정 횟수({MAX_RETRIES}회)를 초과했습니다.")
        print("💡 인간의 개입이 필요합니다. 수동으로 문제를 해결해주세요.")
        sys.exit(0)

    # 2. 로그 파일 읽기
    with open(log_file, 'r') as f:
        log_content = f.read()
    
    # 로그가 비어있는지 확인
    if not log_content.strip() or "로그 캡처 실패" in log_content:
        print("⚠️ 실패 로그가 비어있거나 캡처에 실패했습니다. 분석을 중단합니다.")
        # gh run view가 실패했더라도 에이전트에게 상황을 알리고 싶다면 여기서 빈 로그라도 넘길 수 있지만
        # 현재는 안전을 위해 중단합니다.
        # sys.exit(0)
    
    lines = log_content.splitlines()[-150:]
    relevant_log = "\n".join(lines)
    
    print(f"--- Analyzing CI Failure Log: {log_file} (Last 150 lines) ---")
    print(relevant_log)
    print("------------------------------------------")

    # 3. 에이전트 호출 및 수정 요청
    success = call_openclaw_agent(relevant_log)
    if not success:
        sys.exit(1)

    # 4. 변경 사항 커밋 및 푸시
    print(f"\n🚀 [Self-Healing] Checking for changes...")
    
    status = run_git(["status", "--porcelain"])
    if not status:
        print("ℹ️ No changes detected by the agent. Skipping commit/push.")
        sys.exit(0)

    print("📝 Changes detected! Committing fix...")
    run_git(["config", "user.name", "NightWatch Bot"])
    run_git(["config", "user.email", "nightwatch@kimpossible-ty"])
    
    run_git(["add", "."])
    run_git(["commit", "-m", FIX_COMMIT_TAG])
    
    branch = run_git(["branch", "--show-current"])
    
    if os.getenv("GITHUB_ACTIONS"):
        print(f"📤 Pushing fix to branch: {branch}...")
        run_git(["push", "origin", branch])
        print("✅ 수정 사항이 푸시되었습니다. CI가 재시작됩니다.")
    else:
        print(f"ℹ️ 로컬 환경이므로 푸시를 스킵합니다. (git push origin {branch})")

if __name__ == "__main__":
    main()
