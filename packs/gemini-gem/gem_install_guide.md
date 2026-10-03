# Gemini Gem — detailed install and storage guide

This guide covers **what** to store, **where** (Gem vs local workspace), and **what must not** go into a Gem.

> **Template source folder:** use file paths from **this public template** (or a Template clone). Do not feed the Gem a personal development branch unless it is synced to a clean base.

---

## Two storage places (do not confuse)

| Place | What belongs there | Who maintains it |
|-------|--------------------|------------------|
| **Gemini Gem (cloud)** | Gem instructions + Knowledge files (template rules) | You, in Gem Manager |
| **Local workspace** (`workspace-[project]/`) | Gem-**generated** project-specific files | You copy from the Gem reply; the agent fills logs |

The Gem **does not replace** the workspace — it prepares documents for a new project. Implementation happens in your AI coding agent.

---

## Part 1: Create the Gem (gemini.google.com)

### Step 1 — Open Gem Manager

1. Open [gemini.google.com](https://gemini.google.com) in a browser.
2. From the left, choose **Gems** (or **Gem Manager**).
3. Choose **Create new Gem**.

> The UI can vary by plan (Advanced / Business). Knowledge files often need Gemini Advanced or a workspace feature — if you do not see “Knowledge”, upgrade or use only the Custom Instructions field.

### Step 2 — Basics (name and description)

| Gem field | What to write | Example |
|-----------|---------------|---------|
| **Name** | A recognizable Gem name (not the project name) | `Project kickstart – template` |
| **Description** (optional) | One line for yourself | `Turns a project idea into workspace files.` |

**Do not** name the Gem after the template repo — that is the template, not the Gem name or the user’s project.

### Step 3 — Custom Instructions (required)

| Where | What |
|-------|------|
| Field: **Instructions** / **Custom instructions** | The full file contents |

**Source file in this pack:**

```
packs/gemini-gem/gem_custom_instructions_paste.txt
```

(If you copied the pack into `docs/`, use that path instead.)

**Steps:**

1. Open the file in an editor.
2. Select all (Cmd+A) and copy.
3. Paste into the Gem Instructions field.
4. Do not shorten — critical rules (project types, do not use the template name as the project, no secrets) live there.

When you update instructions later, **replace the entire Instructions field** with the new paste file and save the Gem again.

### Step 4 — Knowledge (recommended, max ~10 files)

Scroll below Instructions → **Knowledge** → **Add files**.

Upload from the **template root** (not a personal fork, not the whole Drive):

| # | File (repo path) | Why the Gem needs it |
|---|------------------|----------------------|
| 1 | `AGENTS.md` (root) | Template constitution: folders, Data-First, token discipline, Gemma |
| 2 | `directives/prompt_template.md` | Correct shape of `current_task.md` |
| 3 | `BEFORE_YOU_START.md` (root) | Task-file roles, security, `.env` vs `mcp_config` |
| 4 | `packs/gemini-gem/gem_workspace_kickstart.md` | Gem usage and project types (optional but useful) |

**Optional** (if Knowledge slots remain):

| File | When |
|------|------|
| `README.md` | Start path for humans and agents |
| `directives/current_task.md` | Blank template — only if you want the Gem to see the current shape |
| `.env.example` | Variable *names* (never `.env`!) |

**Knowledge total:** prefer **4–5 small .md files** over one giant file — easier RAG retrieval.

**Google Drive linking:** If you add a Drive file, the Gem uses the **latest version** for Docs/Sheets. Local .md files: re-upload to the Gem when you change them in the repo.

### Step 5 — Knowledge settings

- **Disable knowledge citations:** leave on (see where guidance came from) or off for cleaner replies.
- **Do not upload** the whole project’s `data/*.xlsx` into Gem Knowledge — they are project-specific and may contain PII.

### Step 6 — Preview and save

1. Use the **Preview** pane: give a one-sentence test idea.
2. Check: the Gem asks for **project name** and **project type**, and does not use the template repo name as the project name.
3. Press **Save**.

Gem settings are stored on **your Google account** (Gems list), not in the local repo.

---

## Part 2: What NOT to store in the Gem

| Do not upload / paste | Why |
|-----------------------|-----|
| `.env` (real keys) | Secrets |
| `mcp_config.json` with keys | Same |
| `data/*.xlsx`, CSV with raw data | PII, size, project-specific — use a local agent / Gemma |
| `temp/` | Temporary; Drive-sync risk |
| The whole repo as a zip | Token waste, stale knowledge |
| Finished `AGENTS.md` from other projects | Confuses generation for the new project |

---

## Part 3: Using the Gem → what to save locally

When the Gem is ready and you are in a chat:

### You provide (chat only, not Gem settings)

```
[Your project idea in 1–3 sentences]
```

Example data project: *"Convert Excel files in the data folder to JSON for analysis."*

### The Gem produces (you copy from the reply)

Each block is shaped `<!-- FILE: path -->` + markdown. Copy into the **new project** folder:

| Gem block | Save locally as |
|-----------|-----------------|
| `FILE: AGENTS.md` | `[project root]/AGENTS.md` |
| `FILE: task_plan.md` | `[project root]/task_plan.md` |
| `FILE: directives/current_task.md` | `[project root]/directives/current_task.md` |
| `FILE: data/schema.json` | `[project root]/data/schema.json` |
| `FILE: .env.example` | merge into existing or replace only new lines |
| `FILE: docs/parking_lot.md` | `[project root]/docs/parking_lot.md` |

**Before the first local agent command:**

1. Copy the template to `workspace-[short-name]` (e.g. `workspace-excel-convert`).
2. Replace/fill the files above with Gem outputs.
3. Copy `.env.example` → `.env` and fill values **only locally**.
4. Put Excel files under **`data/`** (not into the Gem).
5. Tell the agent: `Read AGENTS.md and directives/current_task.md, start the task.`

### What the agent fills (you do not copy from the Gem)

| File | Role |
|------|------|
| `progress.md` | Completion diary |
| `findings.md` | Lessons from failures |
| `scripts/`, `tests/` | Implementation code |

---

## Part 4: Updates when you change the template

| You changed | Action |
|-------------|--------|
| `packs/gemini-gem/gem_custom_instructions_paste.txt` | Update Gem **Instructions** (whole field) → Save |
| `AGENTS.md`, `BEFORE_YOU_START.md`, etc. | Remove the old Knowledge file from the Gem → upload the new version |
| New project type / rule | Retest with the same Preview idea |

---

## Part 5: Quick checklist

**Into the Gem (once / when updating):**

- [ ] Instructions = full `gem_custom_instructions_paste.txt`
- [ ] Knowledge: `AGENTS.md`, `prompt_template.md`, `BEFORE_YOU_START.md`
- [ ] No `.env`, no `data/*.xlsx`
- [ ] Preview test: Gem asks for project name; does not confuse template with project

**Into a new project (each idea):**

- [ ] Copy template → `workspace-[name]`
- [ ] Paste Gem outputs into `AGENTS.md`, `task_plan.md`, `current_task.md`, …
- [ ] `.env` locally
- [ ] Data in `data/` → agent implements

---

## Links

- [Google: Use Gems in Gemini Apps](https://support.google.com/gemini/answer/15146780)
- [Google: Upload files in Gemini](https://support.google.com/gemini/answer/14903178)
- Paste instructions: `packs/gemini-gem/gem_custom_instructions_paste.txt`
- Gem usage: `packs/gemini-gem/gem_workspace_kickstart.md`
