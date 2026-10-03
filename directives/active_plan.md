# Active plan

Julkaisuvalmiuden korjaustoimenpiteet (GitHub Template release fixes).

## Status

Complete — all publish-fix phases done; orphan root commit created.

## Steps

- [x] Vaihe 1: Korjaa `.agents/rules/rollback_guard.md` automaatticommit-ristiriita vastaamaan `AGENTS.md` §6:ta
- [x] Vaihe 2: Puhdista yksityisjäämät `packs/deploy-ubuntu/` -kansiosta (`verho-cron`, `blinds-plan`, `tietosuoja-ydin`)
- [x] Vaihe 3: Nollaa `progress.md` ja `logs/changelog.jsonl` puhtaaseen aloitustilaan
- [x] Vaihe 4: Lisää seuraamattomat dokumentit `docs/github_publish.md` ja `docs/publish_readiness_super_prompt.md` seurantaan
- [x] Vaihe 5: health_check `.env`-viesti + `.github/workflows/verify.yml` + `.gitattributes`
- [x] Vaihe 6: English-canonicalize core `.agents/rules` + `.agents/skills` (+ workflows)
- [x] Vaihe 7: Verifiointi (`security_scan.py --all` + testit) + orphan juuricommit
