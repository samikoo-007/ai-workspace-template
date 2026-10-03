---
name: Hybridi-Deployment
description: Käytä tätä taitoa viedäksesi koodatut projektit tuotantovalmiiksi joko Vercel-julkaisuun (Web) tai Docker-kontteihin (Backend/Automaatiot).
---
# Hybridi-Deployment (Julkaisu) 🚀

Käytä tätä taitoa, kun käyttäjä haluaa "julkaista", "paketoida", "viedä tuotantoon" tai kun olet juuri saanut suuren kokonaisuuden valmiiksi.

## Ohjeet

### 1. Analysoi Teknologia
Selvitä projektin pääasiallinen luonne:
- **Tyyppi A (Web/Frontend):** Sisältää HTML, CSS, React, Vue jne.
- **Tyyppi B (Tausta/Automaatio):** Sisältää Python-skriptejä, tietokantoja, cron-jobeja.

### 2. Valitse Julkaisupulku

**Jos Tyyppi A (Vercel):**
1.  Kopioi `.agents/templates/deployment/vercel.json` projektin juureen.
2.  Luo `DEPLOYMENT.md` tiedosto, johon kirjoitat ohjeet: *"1. Asenna Vercel CLI. 2. Aja komento `vercel deploy` projektin juuressa."*

**Jos Tyyppi B (Docker):**
1.  Kopioi `.agents/templates/deployment/Dockerfile.python` projektin juureen nimellä `Dockerfile`.
2.  Luo juureen `docker-compose.yml`, johon konfiguroit skriptin ajamisen. Varmista, että ympäristömuuttujat luetaan `.env` tiedostosta.
3.  Luo `DEPLOYMENT.md` tiedosto, johon kirjoitat ohjeet: *"1. Varmista, että Docker on asennettu. 2. Aja komento `docker compose up -d` käynnistääksesi palvelut taustalle."*

**CI/CD (suositeltu kun projekti alkaa):**
1.  Kopioi `.agents/templates/deployment/github-actions-ci.yml` → `.github/workflows/ci.yml`
2.  Säädä Python/Node-versiot ja testikomennot projektin tarpeen mukaan.

**Ubuntu LAN -palvelin (24/7 cron, your-project-tyyli):**
1.  Kopioi `deploy/deploy.env.example` → `deploy/deploy.env` ja täytä polut
2.  Luo `deploy/docker-compose.yml` projektin mukaan (tai kopioi your-project:sta)
3.  Skill: `.agents/skills/ubuntu_server_deploy/SKILL.md`
4.  Ensiasennus: `bash deploy/scripts/setup_git_remote.sh --push`
5.  Jokainen julkaisu: `bash deploy/scripts/deploy_to_server.sh all -m "[AI] …"`

### 3. Viimeistely
Kun tiedostot on generoitu, ota aina **Git Checkpoint** (Commit) `git_checkpoint` -taidolla, ennen kuin ilmoitat käyttäjälle onnistumisesta. Esimerkkiviesti: `[AI] Valmisteltu julkaisua varten (Docker/Vercel)`.

## Rajoitteet
- Älä koskaan yritä pakottaa Python-cron-skriptiä Verceliin.
- Älä asenna Dockeria suoraan isäntäkoneelle, neuvo vain käyttäjää.
