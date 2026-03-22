import sys
import os
import subprocess
from pathlib import Path
import json

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
    
    # 에이전트에게 보낼 프롬프트 구성
    prompt = (
        "The CI pipeline has failed. Below is the relevant log content. "
        "Please analyze the error, find the root cause in the workspace, and apply a fix. "
        "Do not just explain; actually modify the code if possible. "
        "If you cannot fix it, explain why.\n\n"
        "--- CI FAILURE LOG ---\n"
        f"{log_content}\n"
        "--- END OF LOG ---\n"
    )

    # GitHub Actions 환경에서 Docker를 통해 에이전트 실행
    if os.getenv("GITHUB_ACTIONS"):
<<<<<<< HEAD
=======
        # nightwatch-agent 이미지를 사용하여 ci-fixer 에이전트 실행
        # 이 부분은 nightwatch_executor.py의 로직을 참고하여 구성합니다.
>>>>>>> a739ad3 (plan: trigger NightWatch for bulk tasks (Series))
        cmd = [
            "docker", "compose", "run", "--rm", "-T",
            "-e", f"GEMINI_API_KEY={os.getenv('GEMINI_API_KEY')}",
            "-e", "OPENCLAW_ACCEPT_RISK=true",
            "nightwatch-agent",
            "openclaw", "agent", "--agent", AGENT_ID, "--message", prompt
        ]
        try:
            subprocess.run(cmd, check=True)
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ 에이전트 실행 실패: {e}")
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

    # 2. 로그 파일 읽기 (마지막 100줄)
    with open(log_file, 'r') as f:
        log_content = f.read()
    
    lines = log_content.splitlines()[-100:]
    relevant_log = "\n".join(lines)
    
    print(f"--- Analyzing CI Failure Log: {log_file} ---")
    print(relevant_log)
    print("------------------------------------------")

    # 3. 에이전트 호출 및 수정 요청
    success = call_openclaw_agent(relevant_log)
    if not success:
        sys.exit(1)

    # 4. 변경 사항 커밋 및 푸시
    print(f"\n🚀 [Self-Healing] Checking for changes...")
    
    # 변경 사항이 있는지 확인
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
        # GITHUB_TOKEN을 사용하여 origin으로 푸시
        run_git(["push", "origin", branch])
        print("✅ 수정 사항이 푸시되었습니다. CI가 재시작됩니다.")
    else:
        print(f"ℹ️ 로컬 환경이므로 푸시를 스킵합니다. (git push origin {branch})")

if __name__ == "__main__":
    main()
