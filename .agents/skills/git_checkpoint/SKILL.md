---
name: Git Checkpoint & Rollback
description: Use for safe local git checkpoints and rollback. Commit only when the user asks, unless the project documents an auto-commit opt-in.
---

# Git Checkpoint & Rollback

Local git is a safety net. **Default: commit only when the user requests it.**

## Always first

```bash
python3 scripts/security_scan.py
```

**FAIL → do not commit.**

## Checkpoint (when asked, or before a risky change the user approved)

1. `python3 scripts/security_scan.py` → PASS
2. `git status`
3. `git add` relevant files only — never `.env` or `mcp_config.json`
4. `git commit -m "[AI] Checkpoint before: <task>"`

## Post-task commit

Only if the user asked to commit (or `AGENTS.md` / project policy opts into auto-commit):

1. Tests + `security_scan.py` PASS
2. Commit with a short message
3. Update `logs/changelog.jsonl` `commit` field

## Rollback

1. `git restore .` for uncommitted changes
2. `git reset` / restore previous commit only with user approval for destructive ops

## Limits

- Never push without an explicit request
- Never commit on `security_scan` FAIL
- Never commit secrets
