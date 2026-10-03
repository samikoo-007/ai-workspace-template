# Tool adapters

Thin glue so the same constitution works across agent hosts.
Keep `AGENTS.md` canonical — adapters only point at it.

| Path | Host |
|------|------|
| `../.cursor/rules/constitution.mdc` | Cursor |
| `CLAUDE.md` (repo root) | Claude Code |
| Project instructions / skills → `AGENTS.md` + `directives/current_task.md` | Antigravity (and hosts without a dedicated file) |

Add more adapters here as needed (Copilot instructions, Windsurf, etc.) without bloating `AGENTS.md`.
