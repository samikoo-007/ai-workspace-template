# Prompt template (example)

Copy the structure below into `current_task.md` when you need a filled example.

---

## Goal
Create a Python script that fetches an RSS feed and saves item titles to `data/`.

## Context & files
- `scripts/fetch_rss.py` (create)
- `.env` — use `API_KEY` only if the feed requires auth

## Constraints
- Use `requests` (add to requirements if needed)
- No new npm packages
- Do not commit secrets

## Success criteria
- [ ] Script runs with `python scripts/fetch_rss.py`
- [ ] Titles written under `data/` (gitignored)
- [ ] Test or smoke check documented in `progress.md`
