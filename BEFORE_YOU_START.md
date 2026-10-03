# Before you start

Welcome to the AI Workspace Template. Copy this folder (or use it as a GitHub Template) before you write project code.

This template shines for **multi-session, steered agent work** (MVP builds, scripts, privacy-aware tooling). It is not meant for one-shot disposable prompts. Publishing maintainers: see `docs/github_publish.md`.

## 1. How work is tracked

| File | Role |
|------|------|
| `task_plan.md` | Long-term roadmap |
| `directives/current_task.md` | The one task the agent should do **now** |
| `directives/active_plan.md` | Agent-owned multi-step plan (only when needed) |
| `progress.md` / `findings.md` | Agent history & incidents |

You steer with `current_task.md`. The agent reports in `progress.md`.

## 2. Human vs agent

| You | Agent |
|-----|--------|
| Define the goal | Plan and implement |
| Set scope / accept tradeoffs | Run commands, tests, fixes |
| Provide secrets when missing | Never invent API keys |

Do **not** paste terminal errors into chat — let the agent run commands.

Official loop: `.agents/workflows/agentic_execution_loop.md`

## 3. Security

- Never put real API keys in `mcp_config.json`. Copy `mcp_config.example.json` → `mcp_config.json` (gitignored). Secrets only in `.env`.
- If this folder lives in Google Drive / Dropbox / iCloud, `temp/` may sync to the cloud. Do not put sensitive raw data there.

## 4. First steps

1. Update `AGENTS.md` section 1 (project vision).
2. Write an MVP in `task_plan.md`.
3. Copy `.env.example` → `.env`.
4. Fill `directives/current_task.md`.
5. Ask the agent to start.

Optional packs (deploy, local LLM, data, web UI): see `packs/README.md`.
