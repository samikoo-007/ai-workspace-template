# Git sync — Mac ↔ Ubuntu Server (SSH bare repo)

Tuotantorepo synkronoidaan **SSH bare-repon** kautta. GitHub ei ole pakollinen.

| Rooli | Polku (oletus) |
|-------|----------------|
| Bare repo (`origin`) | `/srv/<project>/git/<project>.git` |
| Mac kehitys | Google Drive / paikallinen työtila |
| Server checkout | `/srv/<project>/app` |

Konfiguroi polut: `deploy/deploy.env` (kopioi `deploy/deploy.env.example`).

## Ensiasennus (kerran per projekti)

```bash
cp deploy/deploy.env.example deploy/deploy.env
# Muokkaa DEPLOY_* -arvot

bash deploy/scripts/setup_git_remote.sh --push
```

Tämä:
1. Luo bare-repon serverille
2. Asettaa Macin `origin` → `your-server:/srv/.../git/....git`
3. Linkittää serverin app-checkoutin bare-repoon
4. `--push`: pushaa haaran ja fast-forward pull serverille

## Päivittäinen työnkulku (agentti tai ihminen)

**Täysi putki (suositus korjauksen jälkeen):**

```bash
bash deploy/scripts/deploy_to_server.sh all -m "[AI] Fix worker-sync TypeError"
```

Vaiheet erikseen:

```bash
bash deploy/scripts/deploy_to_server.sh verify          # security + testit
bash deploy/scripts/deploy_to_server.sh commit -m "..." # git commit
bash deploy/scripts/deploy_to_server.sh push            # git push origin
bash deploy/scripts/deploy_to_server.sh pull            # server ff-only merge
bash deploy/scripts/deploy_to_server.sh rebuild         # docker compose build worker
bash deploy/scripts/deploy_to_server.sh smoke           # cron smoke serverillä
```

**Huom:** Worker-skriptit ovat Docker-imagessa — `rebuild` on pakollinen kun `scripts/` muuttuu (kuten your-project).

## Ympäristömuuttujat (`deploy/deploy.env`)

| Muuttuja | Kuvaus |
|----------|--------|
| `DEPLOY_SERVER_HOST` | SSH-alias (esim. `your-server`) |
| `DEPLOY_GIT_BARE` | Bare repo serverillä |
| `DEPLOY_APP_DIR` | Tuotantokoodi `/srv/.../app` |
| `DEPLOY_BRANCH` | Deployattava haara |
| `DEPLOY_DOCKER_REBUILD_SERVICES` | Esim. `worker` tai `worker api web` |
| `DEPLOY_SMOKE_CRON_JOBS` | Esim. `worker-sync report-job` |

## Turvallisuus

- `deploy/deploy.env` **ei** versionhallintaan (projektikohtaiset polut)
- `.env` **ei** gitissä — vain serverin `/srv/.../app/.env` (`chmod 600`)
- Mac-kehityksessä pidä kirjoitusportit `.env`:ssä `0`
- Tuotannon portit: projektin `deploy/env.production.*` + cron `-e`-ylikirjoitukset

## your-project -referenssi

```bash
DEPLOY_PROJECT_NAME=your-project
DEPLOY_GIT_BARE=/srv/your-project/git/your-project.git
DEPLOY_APP_DIR=/srv/your-project/app
DEPLOY_DOCKER_REBUILD_SERVICES=worker
DEPLOY_SMOKE_CRON_JOBS=worker-sync
```

Katso myös: `your-project/deploy/GIT_SYNC.md`
