# Gemini Gem: project kickstart from an idea (template workspace)

**Source folder for the Gem:** this public template (or a Template clone). Do not use a personal development copy as Knowledge unless it is freshly synced from a clean base.

This guide is for **Google Gemini Gems**. The Gem turns a one-sentence idea → clarifying questions → proposals → ready content for workspace files (`AGENTS.md`, `task_plan.md`, `directives/current_task.md`, etc.).

## Project name vs template (do not confuse)

| Term | Meaning |
|------|---------|
| **Template** | Workspace structure and rules (this repo before copy). Not the user’s project name. |
| **Project** | The user’s own target — their name and vision. |
| **Folder name** | You may name a copy `workspace-[short-name]` (e.g. `workspace-tournament`). That is a path, not automatically the project brand name. |
| **Do not use as the project name** | The template repo name (e.g. `ai-workspace-template`) — unless the user explicitly chooses that. |

The Gem asks for the **project name** (Phase B) and uses it in all generated files.

**Project types:** App (UI/web), **Data & automation** (e.g. Excel under `data/` → CSV/JSON, Python scripts), or Hybrid. The Gem does not read local files — it plans; the coding agent implements.

---

## 1. What a Gemini Gem needs to work well

The Gem does not “guess” workspace rules — it needs a **clear role, staged workflow, and strict output format**. These elements improve quality most:

| Element | Why it matters |
|---------|----------------|
| **Role** | Who the Gem is (project kickstart planner for this template’s structure). |
| **Goal** | One clear outcome: “produce copy-pasteable file contents; do not code yet”. |
| **Input** | What the user provides: only a 1–3 sentence idea. |
| **Workflow** | Ordered steps: clarify → propose → confirm → print. |
| **Output format** | One file at a time, markdown code blocks, headed `FILE: path`. |
| **Constraints** | No secrets, no invented API keys, one question at a time. |
| **1–2 few-shot examples** | Show the right conversation and output shape. |
| **Knowledge files** | Upload to the Gem: `AGENTS.md`, `directives/prompt_template.md`, `BEFORE_YOU_START.md` (or this doc). |
| **Test inputs** | Keep 3–5 of your own project ideas (different domains) and retest after instruction changes. |

**Avoid:** one long “please help” blob with no stages; many questions at once; confusing `task.md` vs `task_plan.md`; real secrets in `.env` examples.

---

## 2. What the Gem should gather (clarifying questions)

Before generating files, the Gem confirms at least these (**1–2 questions per message**):

0. **Project name** — short name for documents (not the template repo name).
1. **Target users** — roles in the user’s words (no preset assumptions).
2. **Usage context** — device, place, offline need in the user’s words.
3. **MVP scope** — 3–5 must-have features from the user’s goals.
4. **Data core** — entities and storage as the user describes them.
5. **Source of truth** — storage (JSON file, SQLite, cloud API)?
6. **Tech preference** — web (HTML/JS), Python automation, React, etc.?
7. **Publish path** — local only, Vercel web, Docker backend?
8. **Language and a11y** — UI language, WCAG need?
9. **Privacy** — personal data, GDPR, local-only processing (Gemma)?

When these are clear enough, the Gem writes a **short MVP summary** and asks for confirmation before printing files.

---

## 3. Files the Gem produces (template structure)

| File | Role |
|------|------|
| `AGENTS.md` | **This project’s** constitution (user’s project name in the vision): stack, data, skills, memory strategy. |
| `task_plan.md` | High-level roadmap (milestones, not daily micro-tasks). |
| `directives/current_task.md` | **One** first concrete task for the agent. |
| `data/schema.json` | JSON schema (data-first) — if the project is data-led. |
| `docs/parking_lot.md` | Extras that are out of MVP (optional update). |
| `.env.example` | **Variable names and comments only** — no real values. |

**Do not produce:** `progress.md` / `findings.md` (the agent fills these). **Do not confuse:** the agent’s internal `task.md` (brain) vs `task_plan.md` (repo).

---

## 4. Install into a Gem (for the user)

**Detailed guide:** [gem_install_guide.md](gem_install_guide.md) (what goes in the Gem vs the local workspace).

**Quick summary:**

1. **Gemini → Gems → Create new Gem**
2. **Name:** e.g. `Project kickstart (template)` (not the template repo name)
3. **Instructions:** paste all of [`gem_custom_instructions_paste.txt`](gem_custom_instructions_paste.txt)
4. **Knowledge:** upload `AGENTS.md`, `directives/prompt_template.md`, `BEFORE_YOU_START.md` (optional: this kickstart doc)
5. **Do not upload:** `.env`, `data/*.xlsx`, secrets
6. **Save** → test with a Preview idea
7. Gem outputs → copy into a **new** `workspace-[project]/` folder’s files

---

## 5. Usage from the user’s view

```
You: [your project idea, 1–3 sentences]
Gem: [1–2 clarifying questions]
You: [answers]
Gem: [MVP proposal + parking-lot extras]
You: Accept / edit
Gem: [code blocks: AGENTS.md, task_plan.md, current_task.md, ...]
You: Copy contents into the workspace → tell your coding agent:
     "Read AGENTS.md and directives/current_task.md, start."
```

---

## 6. Token savings for the coding agent (Gem → agent)

The Gem does **planning**; your AI coding agent (e.g. Cursor) does **implementation**. Guide the user to:

- Reference files with `@AGENTS.md` and `@directives/current_task.md`.
- Keep one task at a time in `current_task.md`.
- Bulk / sensitive data → local Gemma (`gemma_bridge`).

---

*Updated: Gem guide for the AI Workspace Template.*
