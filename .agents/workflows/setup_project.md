# Setup project workflow

Run when this template is copied into a new project root.

1. Read `BEFORE_YOU_START.md`
2. Update `AGENTS.md` §1 (North Star)
3. Write MVP in `task_plan.md` (gate before coding)
4. Copy `.env.example` → `.env`
5. Optional MCP: `cp mcp_config.example.json mcp_config.json`
6. Install deps only if needed (`pip` / `npm`)
7. Fill `directives/current_task.md`
8. Verify: `python3 scripts/health_check.py` and `python3 scripts/security_scan.py --all`
9. Multi-step work → `directives/active_plan.md`
