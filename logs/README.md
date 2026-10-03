# logs/

| Path | Purpose | Git |
|------|---------|-----|
| `changelog.jsonl` | NDJSON change log | yes |
| `audit/` | Session handoffs | yes |
| `runtime/` | Script runtime logs | no |

## changelog.jsonl schema

One JSON object per line:

```json
{"timestamp":"ISO-8601","actor":"agent|human","trigger":"short","action":"short","files":["path"],"tests":"pass|fail|skipped","commit":null}
```

No secrets or PII.
