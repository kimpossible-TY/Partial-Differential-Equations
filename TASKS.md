# 🛠️ NightWatch Tasks

## [FLASH] Test CI-fixer Agent
Verify the CI-fixer agent works by simulating a failure.

**Instructions:**
1. Create a dummy failure log `dummy_failure.log`.
2. Run the orchestrator: `python3 scripts/ci_fix_orchestrator.py dummy_failure.log`.
3. Check if the agent proposes a valid fix.
