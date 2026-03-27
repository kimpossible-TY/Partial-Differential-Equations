# 🛠️ NightWatch Tasks: Self-Healing CI Test Suite

## [FLASH] Test Case 1: Automatic Fix for Logic Error
Verify that the CI-fixer can detect a simple logic error and repair it.

**Setup:**
1. Create `buggy_math.py` with a simple return value error (e.g., `return a - b` instead of `return a + b`).
2. Create `test_math.py` (at root) with a failing test case: `assert add(1, 2) == 3`.

**Success Criteria:**
- [ ] CI fails on the first run.
- [ ] `ci-fixer` agent is triggered.
- [ ] Agent modifies `buggy_math.py` to fix the logic.
- [ ] Agent pushes the fix, and the second CI run passes.

## [LITE] Clean Up Test Artifacts
Remove dummy test files after verification is complete.
