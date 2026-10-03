---
name: Security Guard
description: Analyze code for security gaps and common vulnerabilities (OWASP Top 10).
---

# Security Guard

Protect workspace code and data from critical mistakes and vulnerabilities.

## Instructions

**Zero tolerance:** no partial acceptance of sensitive-data leaks. See `docs/security_baseline.md`.

0. **Before commit (required):**
   - Run `python3 scripts/security_scan.py`
   - Ensure `.env` and `mcp_config.json` are not staged
   - FAIL → stop, fix, log in `findings.md` if needed

1. **Secrets:**
   - Check every edited and new file for hardcoded API keys or passwords.
   - Secrets **only** in `.env`. `mcp_config.example.json` must not include an `env` block.
   - Never log secrets in `logs/changelog.jsonl`, `progress.md`, or `findings.md` — use `[REDACTED]`.

2. **Injection:**
   - Even local DBs (SQLite): use parameterized queries.
   - XSS: sanitize user input before HTML output; avoid unsafe `innerHTML`.

3. **Auth:** If auth is built, validate and authorize on the server — not only by hiding UI controls.

4. **CORS / API surface:** Keep CORS and connection limits correct for local servers and APIs.

5. **Dependencies:** Avoid and warn about outdated NPM/Python packages with known CVEs.
