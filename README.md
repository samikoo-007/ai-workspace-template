# AI Workspace Template

A lean, MIT-licensed starter for AI-assisted projects (Cursor, Claude Code, Antigravity, and similar agents).

**Positioning:** constitution + one current task + security defaults — without locking you to a stack or a home server.

This is the **public / shareable** template. Private, heavier forks may exist separately; do not merge personal server or product playbooks into core.

## Best fit

| Strong | Weak |
|--------|------|
| Multi-session MVP builds that need memory across chats | One-shot “vibe” prompts with no follow-up |
| Scripts, automations, small APIs, data pipelines (via packs) | Large team monorepos with heavy process tooling |
| Privacy-sensitive local work (`.env`, optional local LLM) | Hosted SaaS with baked-in infra assumptions |
| Focused solo / ADHD-friendly steering (one active task) | Design-only / non-code workflows |

Maintainers publishing to GitHub: see [docs/github_publish.md](docs/github_publish.md).

## Why this exists

Coding agents work better with:

- One clear current task file
- Explicit human vs agent roles
- Security defaults (no secrets in git)
- A short constitution (`AGENTS.md`) instead of tribal knowledge in chat

## Quick start

1. Use this repo as a **GitHub Template**, or clone / copy the folder to `workspace-<your-project>`.
2. Read [BEFORE_YOU_START.md](BEFORE_YOU_START.md).
3. Replace **section 1** in [AGENTS.md](AGENTS.md) with your project vision.
4. Write an MVP milestone in `task_plan.md`.
5. Copy `.env.example` → `.env` (local only).
6. Write the first concrete task in `directives/current_task.md`.
7. Tell the agent: *Read `@AGENTS.md` and `@directives/current_task.md`, then start.*

Optional setup:

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt   # minimal: pytest, python-dotenv

npm install                       # only if you use the JS sample tests
npm test
pytest tests/python/ -v
python3 scripts/security_scan.py --all
python3 scripts/health_check.py
```

## Tracking files

| File | Who writes | Purpose |
|------|------------|---------|
| `task_plan.md` | Human (+ agent) | Roadmap / milestones |
| `directives/current_task.md` | Human | Single active command |
| `directives/active_plan.md` | Agent | Multi-step plan |
| `progress.md` | Agent | Done log |
| `findings.md` | Agent | Incidents & lessons |
| `logs/changelog.jsonl` | Agent | Structured change log |

## Optional packs

Niche features are **not** in the hot path. See [packs/README.md](packs/README.md):

- `deploy-ubuntu` — LAN Ubuntu + Docker deploy scripts
- `local-llm` — local Gemma/Ollama bridge
- `data-python` — scrapers & data templates
- `web-ui` — UI/UX / a11y / deploy skills
- `gemini-gem` — Gemini Gem kickstart docs

## Security

- Secrets only in `.env` (gitignored)
- `mcp_config.json` is gitignored; commit only `mcp_config.example.json`
- Before commit: `python3 scripts/security_scan.py`
- Do not put sensitive data in `temp/` if the folder syncs to cloud storage

Details: [docs/security_baseline.md](docs/security_baseline.md)

## License

[MIT](LICENSE)
