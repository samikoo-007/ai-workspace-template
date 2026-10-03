# Project system rules

This folder (`.agents/rules/`) holds always-on rules that steer agent behavior.

## Defaults

1. **Security first**: Handle API keys via `.env` only — never hardcode secrets.
2. **Code style**: Follow PEP 8 for Python and Prettier-style conventions for JavaScript.
3. **Comments**: Prefer English for code comments in this public template (or the project language after copy).
4. **Temp files**: Put generated temporary data under `temp/`, not the repo root.
