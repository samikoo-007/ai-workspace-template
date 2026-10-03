# Project Constitution (AGENTS.md)

This file is the agent operating system for this workspace.
Copy this folder to start a new project, then replace section 1 with your vision.

> **Language:** English is canonical for agents. Finnish notes are optional for humans.

---

## 0. Token discipline

- One goal per request. Prefer `@path` references over "search the whole repo".
- Do not load optional packs unless the user activates them (see `packs/README.md`).
- Sensitive / bulky data → prefer a local LLM pack (`packs/local-llm`) when available.

## 1. North Star (replace per project)

**Template purpose:** A lean, AI-native starting point for web apps, automations, and data scripts.

Replace this paragraph with the real project goal when you copy the template.

## 2. Tech stack

- **Default:** HTML/JS (ES6+), Python, or whatever you declare here after copy.
- **Styling / frameworks:** declare in `directives/` when chosen.
- **Integrations:** enable MCP via `mcp_config.example.json` → `mcp_config.json` (gitignored). Secrets only in `.env`.

## 3. Data-first rule

Define the JSON/data schema before building UI. Source of truth lives under `data/` (or an external API you document).

## 4. Three layers

| Layer | Where | Role |
|-------|--------|------|
| Directives | `directives/` | What to do |
| Orchestration | `AGENTS.md`, `.agents/` | How the agent decides |
| Execution | `scripts/`, `src/` | Code that does the work |

## 5. Tracking files (strict roles)

1. `task_plan.md` — long-term roadmap / milestones only
2. `directives/current_task.md` — the single active human command
3. `progress.md` — agent diary of completed work
4. `findings.md` — incidents, root causes, lessons
5. `directives/active_plan.md` — multi-step plan (agent-owned; skip for one-step tasks)

### 5b. Audit trail

| Layer | Location | Git |
|-------|----------|-----|
| Task history | `progress.md` | yes |
| Incidents / learning | `findings.md` | yes |
| Session handoff | `logs/audit/` | yes |
| Structured changelog | `logs/changelog.jsonl` | yes |
| Runtime logs | `logs/runtime/` | no |

After each finished task: update `progress.md` and append one NDJSON line to `logs/changelog.jsonl`.
Never log secrets, raw PII, or `.env` values — use `[REDACTED]`.

## 6. Behavioral rules

- **Anti-relay:** run commands yourself; do not ask the user to paste terminal errors.
- **Self-heal:** diagnose and fix; max 3 repair loops, then record in `findings.md`.
- **Secrets:** never in code, MCP JSON, or commits — only `.env`. Run `python3 scripts/security_scan.py` before commit.
- **Focus Guard:** off-scope ideas → `docs/parking_lot.md` (with user permission).
- **ADHD communication:** one thing at a time; end with a clear **Next Action**.
- **Git commits:** only when the user asks (or project policy explicitly opts into auto-commit). Never push without a request.

## 7. QA

- New logic → matching tests under `tests/`.
- Run tests before calling a task done.
- Broken code must not be left as the workspace state.

## 8. Optional packs

Heavy or niche capabilities live under `packs/` and are **off by default**:

| Pack | Purpose |
|------|---------|
| `deploy-ubuntu` | LAN Ubuntu + Docker deploy pipeline |
| `local-llm` | Local Gemma/Ollama bridge |
| `data-python` | Scrapers, pandas-oriented templates |
| `web-ui` | UI/UX, a11y/SEO, Vercel-style deploy skills |
| `gemini-gem` | Gemini Gem kickstart docs |

Activate by copying pack contents into the project root (see `packs/README.md`).

## 9. Deployment (core)

Core template does **not** assume a home server or a specific host.
Use `packs/deploy-ubuntu` or `packs/web-ui` when you need a publish path.

---

*Keep this file short. Project-specific detail belongs in `task_plan.md` and `directives/`.*
