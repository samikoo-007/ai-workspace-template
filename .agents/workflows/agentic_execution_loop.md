# Agentic execution loop

Official closed loop for meaningful tasks.

Related: `AGENTS.md`, `docs/security_baseline.md`, `.agents/rules/qa_guard.md`

```
1. Read AGENTS.md + directives/current_task.md
2. MVP gate: task_plan.md + current_task.md filled? (copied project)
3. Multi-step? → write/update directives/active_plan.md
4. Large change? → ask user before git commit (or follow project opt-in policy)
5. Implement one step at a time
6. Run tests + security_scan.py + health_check.py
7. Failed? → self-heal (max 3x) → findings.md if needed
8. Success? → progress.md + changelog.jsonl + active_plan.md
9. Commit only if the user asked (or auto-commit opt-in is documented)
10. Long session? → logs/audit/ handoff
11. Done → report to user; never ask them to paste errors
```

## Verification (before "done")

```bash
pytest tests/python/ -v          # if Python tests exist
npm test                         # if node_modules present
python3 scripts/security_scan.py # required before any commit
python3 scripts/health_check.py  # recommended
```

## When to ask the human

- Missing secret / `.env` value
- Business or scope decision
- External resource the agent cannot reach
- Self-heal failed 3 times

Do **not** ask for terminal paste-backs.
