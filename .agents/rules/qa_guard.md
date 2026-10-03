# QA Guard Protocol

This rule is a critical quality gate. It keeps broken code out of the workspace.

## 1. Test-along requirement

Every edit or new file that adds functional logic needs a matching test under `tests/`.

## 2. Done checklist

Before telling the user "done" or marking a task complete:

1. **Find tests**: Do tests exist for this code?
2. **Run tests**: Use the `test_runner` skill for all relevant tests.
3. **Security scan**: Run `python3 scripts/security_scan.py` — **FAIL = not done, no commit**.
4. **Document**: Update `progress.md` and `logs/changelog.jsonl` (see `AGENTS.md` §5b).

## 3. Self-healing loop

If a test fails:

1. Read the error carefully.
2. Re-analyze the code.
3. Apply a fix.
4. Re-run tests.
5. Repeat until tests pass, or it is clear the test itself is wrong.

## 4. Exceptions

- Pure documentation changes (e.g. `README.md`, `AGENTS.md`).
- Style-only changes (CSS) that do not affect logic (visual checks still recommended).
- Config templates (e.g. `.env.example`).
