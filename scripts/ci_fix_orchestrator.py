import sys
import os
import subprocess
from pathlib import Path

# ==============================================================================
# 설정
# ==============================================================================
MAX_RETRIES = 2
FIX_COMMIT_TAG = "fix(ci): self-healing fix for CI failure"
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")

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
    # "fix(ci): self-healing..." 메시지가 포함된 최근 커밋 개수를 셉니다.
    logs = run_git(["log", "-n", "10", "--pretty=format:%s"])
    if not logs:
        return 0
    
    count = logs.count(FIX_COMMIT_TAG)
    print(f"🔍 Current self-healing attempts in this branch: {count}/{MAX_RETRIES}")
    return count

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

    with open(log_file, 'r') as f:
        log_content = f.read()

    print(f"--- Analyzing CI Failure Log: {log_file} ---")
    lines = log_content.splitlines()[-100:]
    relevant_log = "\n".join(lines)
    print(relevant_log)
    print("------------------------------------------")

    # 2. 에이전트 분석 및 수정 (현재는 시뮬레이션 로직)
    # TODO: 실제 CI-fixer 에이전트 연동 (Sub-agent 호출)
    if "AssertionError" in relevant_log and "add(1, 2) == 3" in relevant_log:
        proposal = "Fix: Correct the return value in buggy_math.py to perform addition."
        # 시뮬레이션: 실제 파일 수정 (buggy_math.py가 있다고 가정)
        buggy_file = Path("buggy_math.py")
        if buggy_file.exists():
            content = buggy_file.read_text()
            new_content = content.replace("return a - b", "return a + b")
            buggy_file.write_text(new_content)
            print(f"📝 {buggy_file} 파일이 자동으로 수정되었습니다.")
        else:
            print(f"⚠️ {buggy_file} 파일을 찾을 수 없어 수정을 스킵합니다.")
            sys.exit(0)
    else:
        proposal = "Fix: General investigation required. No automatic fix available for this error yet."
        print(f"⚠️ {proposal}")
        sys.exit(0)

    # 3. 변경 사항 커밋 및 푸시
    print(f"\n🚀 [Self-Healing] {FIX_COMMIT_TAG}")
    
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
        print("ℹ️ 로컬 환경이므로 푸시를 스킵합니다. (git push origin " + branch + ")")

if __name__ == "__main__":
    main()
