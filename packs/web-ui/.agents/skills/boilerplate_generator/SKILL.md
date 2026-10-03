---
name: Boilerplate Generator (Projektin Scaffolding)
description: Käytä tätä taitoa uusien projektien automaattiseen alustamiseen ja konfigurointiin (esim. Next.js asennus tai Python-virtuaaliympäristön pystytys).
---

# Boilerplate Generator Skill

Kun aloitat täysin uuden projektin "Workspace KS" -pohjan päälle, käytä tätä taitoa alustamaan teknologiapino nopeasti.

## Suoritusohjeet:
1. **Analysoi tarve:** Tarkista `agents.md` ja selvitä, mikä kieli ja framework on valittu (esim. React/Next.js, Vite, Python).
2. **Automaattinen asennus:** Aja tarvittavat asennuskomennot automaattisesti lokaalisti.
   - **Frontend/Web:** Esim. `npx -y create-next-app@latest ./ --use-npm`. Muista aina käyttää ohittavia komentoja, jotta prosessi on non-interaktiivinen tekoälylle.
   - **Python:** Luo `requirements.txt` ja virtuaaliympäristö (`python -m venv venv`), ja asenna paketit.
3. **Kansioiden siivous:** Poista oletuksena tulevat boilerplate-koodit (esim. Next.js:n oletuslogo, Viten counter-komponentti) ja integroi uusi koodi työtilan omiin rakenteisiin (esim. `src/` tai `scripts/`).
4. **README:n päivitys:** Päivitä projektin juuren `README.md` sisältämään juuri asennetun ympäristön käynnistyskomennot (`npm run dev` tms.).
5. **Tietoturvatarkistus:** Varmista, että paketinhallinta ei vahingossa ylikirjoittanut työtilan kriittisiä `.gitignore` tai `agents.md` tiedostoja.
