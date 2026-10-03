# Security baseline

Zero tolerance for leaking secrets or raw PII into git, logs, or chat.

## Secrets — only `.env`

| Allowed | Forbidden |
|---------|-----------|
| `.env` (gitignored, local) | API keys in source |
| `.env.example` (placeholders) | Keys in `mcp_config.json` |
| `mcp_config.example.json` | Committing `.env` |

## Surfaces

| Surface | Rule |
|---------|------|
| Git | No `.env`, no `mcp_config.json` — run `python3 scripts/security_scan.py` |
| `temp/` | No sensitive data (cloud sync risk) |
| `data/` | No PII without anonymization; default gitignored |
| Logs | Redact with `[REDACTED]` |

## Before commit

```bash
python3 scripts/security_scan.py
# or: npm run security
```

**FAIL = do not commit.**
