# Git sync — Mac ↔ Ubuntu Server (SSH bare repo)

The production repo syncs over an **SSH bare repo**. GitHub is optional.

| Role | Path (default) |
|------|----------------|
| Bare repo (`origin`) | `/srv/<project>/git/<project>.git` |
| Mac development | Local workspace |
| Server checkout | `/srv/<project>/app` |

Configure paths in `deploy/deploy.env` (copy from `deploy/deploy.env.example`).

## First-time setup (once per project)

```bash
cp deploy/deploy.env.example deploy/deploy.env
# Edit DEPLOY_* values

bash deploy/scripts/setup_git_remote.sh --push
```

This will:

1. Create the bare repo on the server
2. Point Mac `origin` → `your-server:/srv/.../git/....git`
3. Link the server app checkout to the bare repo
4. `--push`: push the branch and fast-forward pull on the server

## Daily workflow (agent or human)

**Full pipeline (recommended after a fix):**

```bash
bash deploy/scripts/deploy_to_server.sh all -m "[AI] Fix worker-sync TypeError"
```

Steps separately:

```bash
bash deploy/scripts/deploy_to_server.sh verify          # security + tests
bash deploy/scripts/deploy_to_server.sh commit -m "..." # git commit
bash deploy/scripts/deploy_to_server.sh push            # git push origin
bash deploy/scripts/deploy_to_server.sh pull            # server ff-only merge
bash deploy/scripts/deploy_to_server.sh rebuild         # docker compose build worker
bash deploy/scripts/deploy_to_server.sh smoke           # cron smoke on server
```

**Note:** Worker scripts live in the Docker image — `rebuild` is required when `scripts/` changes (as with `your-project`).

## Environment variables (`deploy/deploy.env`)

| Variable | Description |
|----------|-------------|
| `DEPLOY_SERVER_HOST` | SSH alias (e.g. `your-server`) |
| `DEPLOY_GIT_BARE` | Bare repo on the server |
| `DEPLOY_APP_DIR` | Production code `/srv/.../app` |
| `DEPLOY_BRANCH` | Branch to deploy |
| `DEPLOY_DOCKER_REBUILD_SERVICES` | e.g. `worker` or `worker api web` |
| `DEPLOY_SMOKE_CRON_JOBS` | e.g. `worker-sync report-job` |

## Security

- `deploy/deploy.env` is **not** in version control (project-specific paths)
- `.env` is **not** in git — only on the server at `/srv/.../app/.env` (`chmod 600`)
- On Mac development, keep write ports in `.env` set to `0`
- Production ports: project `deploy/env.production.*` + cron `-e` overrides

## your-project reference

```bash
DEPLOY_PROJECT_NAME=your-project
DEPLOY_GIT_BARE=/srv/your-project/git/your-project.git
DEPLOY_APP_DIR=/srv/your-project/app
DEPLOY_DOCKER_REBUILD_SERVICES=worker
DEPLOY_SMOKE_CRON_JOBS=worker-sync
```

See also: `your-project/deploy/GIT_SYNC.md`
