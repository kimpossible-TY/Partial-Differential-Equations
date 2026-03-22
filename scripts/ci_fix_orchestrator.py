import sys
import os
import subprocess
<<<<<<< HEAD
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
=======
>>>>>>> 62890df (fix: resolve gateway token mismatch and configure ci-fixer)

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 ci_fix_orchestrator.py <log_file>")
        sys.exit(1)

    log_file = sys.argv[1]
    if not os.path.exists(log_file):
        print(f"Error: Log file {log_file} not found.")
        sys.exit(1)

    with open(log_file, 'r') as f:
        log_content = f.read()

    print(f"--- Analyzing CI Failure Log: {log_file} ---")
    print(log_content)
    print("------------------------------------------")

    # Simulate agent analysis and fix proposal
    if "SyntaxError" in log_content:
        proposal = "Fix: Correct the syntax error by adding a missing colon on line 10."
    elif "ImportError" in log_content:
        proposal = "Fix: Install the missing dependency 'requests' using pip."
    else:
        proposal = "Fix: General investigation required. Check logic on line 42."

    print(f"\n[CI-Fixer Agent] Proposing fix:")
    print(f">>> {proposal}")

if __name__ == "__main__":
    main()
