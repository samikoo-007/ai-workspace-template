# Publish this template to GitHub

This repo is an **AI Workspace Template**: a lean operating system for coding agents (Cursor, Claude Code, Antigravity, and similar). Publish it as a **public GitHub Template** so others can start projects with the same steering loop — not as a finished app.

## What this structure is optimized for

Agents perform best here when work is **steered, stateful, and security-aware**.

| Best fit | Why the structure helps |
|----------|-------------------------|
| Multi-session builds (MVP → iterate) | `current_task.md` + `progress.md` + `active_plan.md` survive chat resets |
| Scripts, automations, small APIs | Data-first (`data/`), `scripts/`, tests, security scan |
| Privacy-sensitive local tooling | `.env` only, local-LLM pack, no secrets in MCP JSON |
| ADHD / focus-friendly solo work | One active task, Focus Guard → parking lot |
| Pack-on-demand product work | Core stays lean; activate `web-ui`, `data-python`, `deploy-ubuntu` when needed |

| Weak fit (do not market as) | Why |
|-----------------------------|-----|
| One-shot “vibe code this in one prompt” | Overhead of tracking files is wasted |
| Large team monorepo with Jira/PR ceremony | No built-in product/issue tracker integration |
| Hosted SaaS with baked-in infra | Core intentionally has no home-server assumptions |
| Pure design/Figma-only workflows | Strength is code + agent ops, not design handoff |

**Positioning one-liner (README / GitHub description):**  
*Lean MIT starter that gives coding agents a constitution, one current task, and security defaults — without locking you to a stack or a home server.*

## Consumer journey (what GitHub visitors should do)

1. **Use as template** → create a new repo (or clone).
2. Read `BEFORE_YOU_START.md`.
3. Set North Star in `AGENTS.md` §1 + MVP in `task_plan.md`.
4. Copy `.env.example` → `.env`.
5. Write `directives/current_task.md`.
6. In the agent: *Read `@AGENTS.md` and `@directives/current_task.md`, then start.*

Host adapters already in tree:

| Host | Entry |
|------|--------|
| Cursor | `.cursor/rules/constitution.mdc` → `AGENTS.md` |
| Claude Code | `CLAUDE.md` |
| Antigravity / other | Follow `AGENTS.md` + `directives/`; add a thin file under `adapters/` if the host needs a named entrypoint |

## Pre-publish scrub checklist

Run before the first public push (and before every major template release).

### Identity & privacy

- [ ] No personal emails, real names as contacts, or private org names in tracked docs
- [ ] No LAN hostnames, Tailscale names, or private IPs (e.g. `192.168.*`)
- [ ] No product-specific playbooks from a private fork (`workspace-ks`, client names)
- [ ] `packs/gemini-gem/` and other packs use **generic** folder names in docs (not a private path)
- [ ] `progress.md` / `findings.md` / `logs/` contain only template placeholders (no real session PII)

### Secrets & config

- [ ] `.env` is **not** tracked (only `.env.example` with placeholders)
- [ ] `mcp_config.json` is **not** tracked (only `mcp_config.example.json`)
- [ ] `deploy/deploy.env` and similar local deploy files are gitignored / absent
- [ ] `python3 scripts/security_scan.py --all` exits 0
- [ ] `git grep -E 'sk-|ghp_|glpat-|AKIA|BEGIN .*PRIVATE KEY'` on tracked files is clean (or only placeholders)

### Template honesty

- [ ] `AGENTS.md` §1 still describes the **template purpose**, not a private project vision
- [ ] `task_plan.md` backlog is empty or generic
- [ ] `directives/current_task.md` is the blank template (not a live task)
- [ ] Core stays lean; niche content lives under `packs/`
- [ ] License is MIT and accurate

### GitHub product settings (after create)

- [ ] Repository → **Template repository** enabled
- [ ] Description = positioning one-liner above
- [ ] Topics (suggested): `ai-agents`, `cursor`, `claude-code`, `devtools`, `template`, `mit`
- [ ] Default branch protected only if you accept PRs; otherwise keep simple
- [ ] No Actions required for v1; optional later under `packs/web-ui`

## Create / update the public repo

### Option A — first publish (`gh`)

From a clean working tree (after scrub):

```bash
python3 scripts/security_scan.py --all
# Confirm scrub checklist above

gh repo create YOUR_ORG/ai-workspace-template \
  --public \
  --source=. \
  --remote=origin \
  --description "Lean MIT starter: constitution + current task + security defaults for coding agents" \
  --push
```

Then enable **Template repository** in GitHub Settings → General.

### Option B — already have a remote

```bash
python3 scripts/security_scan.py --all
git push -u origin HEAD
```

Enable **Template repository** in the GitHub UI.

### Option C — sync from a private fuller fork

Private workspaces may keep heavier conventions. When promoting changes **into** this public template:

1. Generalize (no personal hosts, no product names).
2. Put niche features in `packs/`, not core.
3. Prefer English in agent-facing files.
4. Open a PR against the public template with a short “why”.

Do **not** merge private product playbooks into core.

## What to put in the GitHub About / README hero

Lead with **agent operating system**, not a framework.

Suggested README sections order (already largely present):

1. What / why (agent OS)
2. Best-fit use cases (link this doc or a short table)
3. Quick start (template → North Star → current_task)
4. Tracking files table
5. Optional packs
6. Security
7. License

Link consumers here for maintainers: *“Publishing or forking as a public template? See `docs/github_publish.md`.”*

## Release hygiene

| Cadence | Action |
|---------|--------|
| Every public push | Security scan + scrub checklist |
| Meaningful template change | Short note in `progress.md` + `logs/changelog.jsonl` |
| Breaking layout change | Call out in README / release notes (e.g. renamed tracking files) |

Commits: only when the human asks (see `AGENTS.md` §6). Never force-push secrets “fixes” — rotate keys if anything leaked.

## Antigravity / Cursor note for publishers

Both hosts should load the same constitution:

- Cursor: always-on rule points at `AGENTS.md`
- Antigravity: point project instructions / skills at `AGENTS.md` and `directives/current_task.md`
- Do not fork agent rules into divergent copies; keep `AGENTS.md` canonical and use thin adapters

## Done criteria for “published”

- [ ] Public repo exists and is marked as a **template**
- [ ] Fresh “Use this template” clone boots with blank `current_task.md` and template North Star
- [ ] Security scan passes on a clean tree
- [ ] README states best-fit use cases and points to `BEFORE_YOU_START.md`
- [ ] Optional second opinion: run the prompt in `docs/publish_readiness_super_prompt.md` on another model
