# Rollback Guard Protocol

Keeps version control clean and makes rollback always possible.

## 1. Clean working tree

Do not start a new, large Directives-level task (e.g. building a feature) while `git status` shows uncommitted changes.

## 2. Commit policy

Commit **only** when the user asks, or when the project documents an explicit auto-commit opt-in (`AGENTS.md` §6).
Do not run `git add` / `git commit` without permission. Never push without an explicit request.
Before any commit: `python3 scripts/security_scan.py` — **FAIL = no commit**. Use the `git_checkpoint` skill.

## 3. Rollback trigger

If the agent makes a mistake and the self-healing loop fails three (3) times in a row, stop, apologize, and propose restoring code (rollback) to the last known-good state via the `git_checkpoint` skill.
