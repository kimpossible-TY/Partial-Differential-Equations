import sys
import os
import subprocess
from pathlib import Path

# ==============================================================================
# Configuration
# ==============================================================================
MAX_RETRIES = 2
FIX_COMMIT_TAG = "fix(ci): self-healing fix for CI failure"

def run_git(args):
    """Executes a git command and returns the output."""
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
    """Checks the commit log for self-healing attempts."""
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

    # 1. Check retry limit (Prevent infinite loop)
    if check_retry_limit() >= MAX_RETRIES:
        print(f"🚨 [Limit Reached] Maximum autonomous fix attempts ({MAX_RETRIES}) reached for this branch.")
        print("💡 Human intervention required.")
        sys.exit(0)

    with open(log_file, 'r') as f:
        log_content = f.read()

    print(f"--- Analyzing CI Failure Log: {log_file} ---")
    lines = log_content.splitlines()[-100:]
    relevant_log = "\n".join(lines)
    print(relevant_log)
    print("------------------------------------------")

    # 2. Agent Analysis (Simulation for test)
    if "non_existent_library" in relevant_log:
        proposal = "Fix: Agent cannot fix missing external library dependency."
        print(f"⚠️ {proposal}")
        sys.exit(0)
    else:
        proposal = "Fix: Attempting fix..."
        print(f"🚀 [Self-Healing] {FIX_COMMIT_TAG}")
        run_git(["add", "."])
        run_git(["commit", "-m", FIX_COMMIT_TAG])
        branch = run_git(["branch", "--show-current"])
        print(f"✅ Fix pushed to {branch} (simulated)")

if __name__ == "__main__":
    main()
