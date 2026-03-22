# 🛠️ NightWatch Tasks

## [PRO] Implement Self-Healing CI Workflow
**Status:** In Progress

- [x] **Orchestrator Logic**: Updated `scripts/ci_fix_orchestrator.py` with retry limits (max 2) and git history checking. Added real agent call logic.
- [x] **Agent Initialization**: Initialized `ci-fixer` agent with SOUL, IDENTITY, AGENTS, and manifest.
- [x] **Workflow Update**: Modified `.github/workflows/nightwatch-ci.yml` to trigger the orchestrator on failure and capture logs.
- [ ] **Verification**: Run a manual test in the CI environment (PR) to confirm the full loop works.

## [FLASH] Test Self-Healing Guardrails
Verify that the orchestrator stops after reaching the retry limit.

**Instructions:**
1. Create a branch with 2 existing "fix(ci): self-healing..." commits.
2. Run the orchestrator.
3. Confirm it exits with a "Retry limit reached" message instead of attempting a 3rd fix.
