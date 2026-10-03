# Ubuntu Server — commit → git → deploy → smoke

Tämä kansio on **tuotantoputki** projekteille, jotka ajetaan 24/7 Ubuntu LAN -palvelimella (kuten `your-project`).

Mac / Google Drive -työtila = kehitys. Tuotanto = serverin `/srv/<project>/`.

## Pika-aloitus

```bash
# 1. Konfiguroi (kerran)
cp deploy/deploy.env.example deploy/deploy.env
# Muokkaa DEPLOY_* -polut ja smoke-jobit

# 2. Git remote (kerran)
bash deploy/scripts/setup_git_remote.sh --push

# 3. Jokainen deploy
bash deploy/scripts/deploy_to_server.sh all -m "[AI] Kuvaus muutoksesta"
```

## Putken vaiheet

| Vaihe | Komento | Mitä tapahtuu |
|-------|---------|---------------|
| **Verify** | `deploy_to_server.sh verify` | `security_scan` + `health_check` + pytest |
| **Commit** | `... commit -m "..."` | Git commit (ei `.env` / salaisuuksia) |
| **Push** | `... push` | `git push origin $BRANCH` |
| **Pull** | `... pull` | Server: `git fetch && merge --ff-only` |
| **Rebuild** | `... rebuild` | `docker compose build worker` (skriptit imagessa!) |
| **Smoke** | `... smoke` | Cron-jobit + `deploy/smoke_remote.sh` |

## npm-skriptit

```bash
npm run deploy:verify
npm run deploy:smoke
npm run deploy:all -- -m "[AI] viesti"
```

## Tiedostot

| Tiedosto | Rooli |
|----------|-------|
| `deploy.env.example` | Malli — kopioi → `deploy.env` |
| `scripts/deploy_to_server.sh` | Pääorkestraattori |
| `scripts/pre_deploy_check.sh` | Paikalliset tarkistukset |
| `scripts/setup_git_remote.sh` | SSH bare repo -asennus |
| `scripts/smoke_test.sh` | Local / remote smoke |
| `smoke_remote.example.sh` | Kopioi → `smoke_remote.sh` (projektikohtainen) |
| `GIT_SYNC.md` | Git-työnkulku |

## Agentti

Cursor-agentti: **`.agents/skills/ubuntu_server_deploy/SKILL.md`**

Käytä kun käyttäjä pyytää: commit, deploy, push serverille, smoke-test, tuotantokorjaus.

## Vaatimukset serverillä

- Ubuntu + Docker Compose
- `deploy`-käyttäjä (tai projektin SSH-käyttäjä)
- App checkout: `/srv/<project>/app` + `.env` (`chmod 600`)
- Cron: `deploy/cron/*.crontab` (luo projektin mukaan — ei mukana tässä mallipohjassa)

## Vercel / pilvi

Web-only projekteille käytä edelleen `.agents/skills/deployment/SKILL.md` (Vercel). Tämä `deploy/`-puu on **LAN-serveri + Docker worker** -mallille.
