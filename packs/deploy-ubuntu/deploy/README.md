# Ubuntu Server — commit → git → deploy → smoke

This folder is a **production pipeline** for projects that run 24/7 on an Ubuntu LAN server (e.g. `your-project`).

Local Mac workspace = development. Production = server `/srv/<project>/`.

## Quick start

```bash
# 1. Configure (once)
cp deploy/deploy.env.example deploy/deploy.env
# Edit DEPLOY_* paths and smoke jobs

# 2. Git remote (once)
bash deploy/scripts/setup_git_remote.sh --push

# 3. Every deploy
bash deploy/scripts/deploy_to_server.sh all -m "[AI] Describe the change"
```

## Pipeline stages

| Stage | Command | What it does |
|-------|---------|--------------|
| **Verify** | `deploy_to_server.sh verify` | `security_scan` + `health_check` + pytest |
| **Commit** | `... commit -m "..."` | Git commit (no `.env` / secrets) |
| **Push** | `... push` | `git push origin $BRANCH` |
| **Pull** | `... pull` | Server: `git fetch && merge --ff-only` |
| **Rebuild** | `... rebuild` | `docker compose build worker` (scripts live in the image!) |
| **Smoke** | `... smoke` | Cron jobs + `deploy/smoke_remote.sh` |

## npm scripts

```bash
npm run deploy:verify
npm run deploy:smoke
npm run deploy:all -- -m "[AI] message"
```

## Files

| File | Role |
|------|------|
| `deploy.env.example` | Template — copy → `deploy.env` |
| `scripts/deploy_to_server.sh` | Main orchestrator |
| `scripts/pre_deploy_check.sh` | Local checks |
| `scripts/setup_git_remote.sh` | SSH bare-repo setup |
| `scripts/smoke_test.sh` | Local / remote smoke |
| `smoke_remote.example.sh` | Copy → `smoke_remote.sh` (project-specific) |
| `GIT_SYNC.md` | Git workflow |

## Agent

Cursor agent skill: **`.agents/skills/ubuntu_server_deploy/SKILL.md`**

Use when the user asks for: commit, deploy, push to server, smoke test, production fix.

## Server requirements

- Ubuntu + Docker Compose
- `deploy` user (or the project SSH user)
- App checkout: `/srv/<project>/app` + `.env` (`chmod 600`)
- Cron: `deploy/cron/*.crontab` (create per project — not shipped in this template)

## Vercel / cloud

For web-only projects, keep using `.agents/skills/deployment/SKILL.md` (Vercel). This `deploy/` tree is for the **LAN server + Docker worker** model.
