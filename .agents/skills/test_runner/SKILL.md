---
name: Test Runner
description: Run automated tests and verify code quality. Supports Python (pytest) and JavaScript (vitest/jest).
---
# Test Runner

Use whenever you create new code or change existing logic.

## Steps

1. **Detect language**: Python or JavaScript.
2. **Create a test**: If missing, add one under `tests/` (e.g. `tests/python/test_logic.py`).
3. **Run tests**:
   - **Python**: `pytest` (e.g. `pytest tests/python`).
   - **JavaScript**: `npm test` or `vitest`.
4. **Interpret results**:
   - Pass → mark the task done (after other done-gates).
   - Fail → self-heal, then re-run tests.

## Limits

- Never skip a failing test.
- Cover at least the critical edge cases.
