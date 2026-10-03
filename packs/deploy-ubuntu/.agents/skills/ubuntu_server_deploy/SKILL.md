---
name: ubuntu_server_deploy
description: >-
  Ubuntu LAN server pipeline: commit → git push → deploy → smoke.
  Use when the user asks to commit, push, deploy to the server, run a smoke
  test, fix production cron, or repeat a your-project-style release flow.
  Configure deploy/deploy.env before the first run.
---
# Ubuntu Server Deploy

Full release pipeline from Mac development to Ubuntu LAN production (`your-server` style).

## When to use

- User: "commit + deploy", "push to server", "smoke test", "fix in production"
- After a cron / worker fix
- **Do not** use for Vercel-only frontends → `deployment/SKILL.md`

## Prerequisites (once per project)

1. `cp deploy/deploy.env.example deploy/deploy.env` — fill in `DEPLOY_*`
2. `bash deploy/scripts/setup_git_remote.sh --push`
3. On the server: app checkout, `.env`, cron (project docs)
4. Optional: `cp deploy/smoke_remote.example.sh deploy/smoke_remote.sh`

## Agent workflow (required order)

### 1. Verify (always first)

```bash
bash deploy/scripts/deploy_to_server.sh verify
```

On failure → fix code/tests, **do not deploy**.

### 2. Commit (when the user asks, or post-task if policy allows)

```bash
python3 scripts/security_scan.py --all   # if not just run in verify
bash deploy/scripts/deploy_to_server.sh commit -m "[AI] <what changed>"
```

- **Never commit** `.env`, `deploy/deploy.env`, `mcp_config.json`
- Commit only when tests + security_scan PASS

### 3. Push + pull + rebuild + smoke

**One command:**

```bash
bash deploy/scripts/deploy_to_server.sh all -m "[AI] <what changed>"
```

**Or separately** (debug):

```bash
bash deploy/scripts/deploy_to_server.sh push
bash deploy/scripts/deploy_to_server.sh pull
bash deploy/scripts/deploy_to_server.sh rebuild
bash deploy/scripts/deploy_to_server.sh smoke
```

### 4. Report results

Tell the user:

- Git commit hash (if committed)
- Server: `git log -1` after pull
- Smoke: cron-job status (`status=ok` / error)
- Next cron time (if relevant)

## Critical rules

| Rule | Why |
|------|-----|
| **`rebuild` after worker** when `scripts/` changes | Scripts are in the Docker image, not bind-mounted |
| **`deploy/deploy.env` not in git** | Project-specific paths |
| **Mac `.env` write ports = 0** | Fail-safe |
| **Production smoke without live writes** when possible | Dry-run cron or read-only job first |
| **Push only after verify+commit** | No broken code on the server |

## Smoke test configuration

`deploy/deploy.env`:

```bash
DEPLOY_SMOKE_CRON_JOBS=worker-sync
DEPLOY_DOCKER_REBUILD_SERVICES=worker
```

Live-write cron needs the same `-e` environment as crontab (project docs).

Read-only smoke first:

```bash
ssh your-server 'cd /srv/.../app && docker compose ... run --rm worker python scripts/cron_runner.py --job report-job'
```

## your-project example

```bash
# deploy/deploy.env
DEPLOY_PROJECT_NAME=your-project
DEPLOY_GIT_BARE=/srv/your-project/git/your-project.git
DEPLOY_APP_DIR=/srv/your-project/app
DEPLOY_DOCKER_REBUILD_SERVICES=worker
DEPLOY_SMOKE_CRON_JOBS=report-job
```

```bash
bash deploy/scripts/deploy_to_server.sh all -m "[AI] Fix report-job TypeError"
```

## Troubleshooting

| Problem | Action |
|---------|--------|
| `Permission denied (publickey)` | SSH keys / `your-server` alias |
| `merge --ff-only` fail | Rebase on Mac or merge manually on server |
| Smoke fails after rebuild | Run the job manually in the container; read traceback |
| `already_sent` ntfy | Cron already notified — check `cron_job_status.json` |

## Related skills

- `git_checkpoint` — commit/rollback before deploy
- `deployment` — Vercel/Docker scaffold for new projects
- `security_guard` — secrets

## Sources

- `deploy/README.md`
- `deploy/GIT_SYNC.md`
- `your-project/deploy/GIT_SYNC.md` (reference implementation)
