---
name: ubuntu_server_deploy
description: >-
  Ubuntu LAN -palvelimen commit → git push → deploy → smoke -putki.
  Käytä kun käyttäjä pyytää commitoida, pushata, deployata serverille,
  ajaa smoke-testin, korjata tuotantocronin tai toistaa your-project-tyylinen
  julkaisuprosessi. Konfiguroi deploy/deploy.env ennen ensimmäistä ajoa.
---
# Ubuntu Server Deploy 🚀

Täydellinen julkaisuputki Mac-kehityksestä Ubuntu LAN -tuotantoon (`your-server`-tyyli).

## Milloin käyttää

- Käyttäjä: "commit + deploy", "push serverille", "smoke test", "korjaa tuotannossa"
- Cron / worker-korjauksen jälkeen
- **Älä** käytä Vercel-only frontend -projekteihin → `deployment/SKILL.md`

## Esivalmistelut (kerran per projekti)

1. `cp deploy/deploy.env.example deploy/deploy.env` — täytä `DEPLOY_*`
2. `bash deploy/scripts/setup_git_remote.sh --push`
3. Serverillä: app checkout, `.env`, cron (projektin docs)
4. Valinnainen: `cp deploy/smoke_remote.example.sh deploy/smoke_remote.sh`

## Agentin työnkulku (pakollinen järjestys)

### 1. Verify (aina ensin)

```bash
bash deploy/scripts/deploy_to_server.sh verify
```

Epäonnistuu → korjaa koodi/testit, **älä deployaa**.

### 2. Commit (käyttäjän pyynnöstä tai post-task)

```bash
python3 scripts/security_scan.py --all   # jos ei juuri ajettu verifyssä
bash deploy/scripts/deploy_to_server.sh commit -m "[AI] <mitä tehtiin>"
```

- **Älä committaa** `.env`, `deploy/deploy.env`, `mcp_config.json`
- Commit vain kun testit + security_scan PASS

### 3. Push + pull + rebuild + smoke

**Yksi komento:**

```bash
bash deploy/scripts/deploy_to_server.sh all -m "[AI] <mitä tehtiin>"
```

**Tai erikseen** (debug):

```bash
bash deploy/scripts/deploy_to_server.sh push
bash deploy/scripts/deploy_to_server.sh pull
bash deploy/scripts/deploy_to_server.sh rebuild
bash deploy/scripts/deploy_to_server.sh smoke
```

### 4. Tulosten raportointi

Ilmoita käyttäjälle:
- Git commit hash (jos commit)
- Server: `git log -1` tulos pull-vaiheesta
- Smoke: cron-job status (`status=ok` / virhe)
- Seuraava cron-aika (jos relevantti)

## Kriittiset säännöt

| Sääntö | Miksi |
|--------|-------|
| **`rebuild` workerin jälkeen** kun `scripts/` muuttuu | Skriptit ovat Docker-imagessa, ei bind-mount |
| **`deploy/deploy.env` ei gitissä** | Projektikohtaiset polut |
| **Mac `.env` kirjoitusportit = 0** | Fail-Safe |
| **Tuotanto-smoke ilman live-kirjoituksia** kun mahdollista | Dry-run cron tai read-only job ensin |
| **Push vain verify+commit jälkeen** | Ei rikkinäistä koodia serverille |

## Smoke-testin konfigurointi

`deploy/deploy.env`:

```bash
DEPLOY_SMOKE_CRON_JOBS=worker-sync
DEPLOY_DOCKER_REBUILD_SERVICES=worker
```

Live-kirjoitus cron vaatii saman `-e`-ympäristön kuin crontab (projektin docs).

Read-only smoke ensin:

```bash
ssh your-server 'cd /srv/.../app && docker compose ... run --rm worker python scripts/cron_runner.py --job report-job'
```

## your-project -esimerkki

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

## Virhetilanteet

| Ongelma | Toimenpide |
|---------|------------|
| `Permission denied (publickey)` | SSH-avaimet / `your-server` alias |
| `merge --ff-only` fail | Rebase Macilla tai serverillä manuaalinen merge |
| Smoke fail rebuildin jälkeen | Aja job manuaalisesti containerissa, lue traceback |
| `already_sent` ntfy | Cron jo ilmoitti — tarkista `cron_job_status.json` |

## Liittyvät skillit

- `git_checkpoint` — commit/rollback ennen deploya
- `deployment` — Vercel/Docker scaffold uusille projekteille
- `security_guard` — salaisuudet

## Lähteet

- `deploy/README.md`
- `deploy/GIT_SYNC.md`
- `your-project/deploy/GIT_SYNC.md` (referenssitoteutus)
