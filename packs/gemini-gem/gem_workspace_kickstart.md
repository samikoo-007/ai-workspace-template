# Gemini Gem: projektin käynnistys ideasta (mallipohja-työtila)

**Lähdekansio Gemille:** tämä julkinen mallipohja (tai sen Template-klooni). Älä käytä henkilökohtaista kehityskopiota Knowledge-tiedostojen lähteenä, ellei se ole juuri synkronoitu puhdasta pohjaa.

Tämä ohje on tarkoitettu **Google Gemini Gems** -työkaluun. Gem muuttaa yhden lauseen idean → tarkentavat kysymykset → ehdotukset → valmiit sisällöt työtilan tiedostoihin (`agents.md`, `task_plan.md`, `directives/current_task.md`, jne.).

## Projektin nimi vs mallipohja (älä sekoita)

| Termi | Mitä tarkoittaa |
|-------|------------------|
| **Mallipohja** | Työtilan rakenne ja säännöt (tämä repo ennen kopioita). Ei ole käyttäjän projektin nimi. |
| **Projekti** | Käyttäjän oma kohde — oma nimi ja visio. |
| **Kansion nimi** | Voit nimetä kopion `workspace-[lyhyt-nimi]` (esim. `workspace-turnaus`). Tämä on polku, ei automaattisesti projektin brändinimi. |
| **Älä käytä projektin nimenä** | Mallipohjan repo-nimeä (esim. `ai-workspace-template`) — paitsi jos käyttäjä nimeää projektin näin erikseen. |

Gem kysyy **projektin nimen** (Vaihe B) ja käyttää sitä kaikissa generoiduissa tiedostoissa.

**Projektityypit:** Sovellus (UI/web), **Data & automaatio** (esim. Excel `data/`-kansiossa → CSV/JSON, Python-skriptit), tai Hybridi. Gem ei lue paikallisia tiedostoja — se suunnittelee; agentti toteuttaa.

---

## 1. Mitä Gemini Gem tarvitsee toimiakseen erinomaisesti

Gem ei “arvaa” työtilan sääntöjä — se tarvitsee **selkeän roolin, vaiheistetun työnkulun ja tiukan tulostemuodon**. Tutkimuksen ja käytännön perusteella nämä elementit nostavat laatua eniten:

| Elementti | Miksi tärkeä |
|-----------|----------------|
| **Rooli (Role)** | Kuka Gem on (projektin käynnistyssuunnittelija mallipohjan rakenteen mukaan). |
| **Tavoite (Goal)** | Yksi selkeä lopputulos: “tuota kopioitavat tiedostosisällöt, älä koodaa vielä”. |
| **Syöte (Input)** | Mitä käyttäjä antaa: vain idea 1–3 lauseena. |
| **Työnkulku (Workflow)** | Vaiheet järjestyksessä: tarkenna → ehdota → vahvista → tulosta. |
| **Tulostemuoto (Output)** | Tiedosto kerrallaan, markdown-koodilohkoina, otsikolla `FILE: polku`. |
| **Rajoitteet (Constraints)** | Ei salaisuuksia, ei keksittyjä API-avaimia, yksi kysymys kerrallaan. |
| **1–2 few-shot -esimerkkiä** | Näyttää oikean keskustelun ja oikean tulosteen muodon. |
| **Knowledge-tiedostot** | Lataa Gemiin: `agents.md`, `directives/prompt_template.md`, `BEFORE_YOU_START.md` (tai tämä doc). |
| **Testisyötteet** | Tallenna 3–5 omaa projekti-ideaasi (eri toimialoja) ja testaa uudelleen ohjeen muutosten jälkeen. |

**Älä tee näin:** yksi pitkä “ole hyvä ja auta” -teksti ilman vaiheita; useita kysymyksiä kerralla; sekava `task.md` vs `task_plan.md`; oikeita salaisuuksia `.env`-esimerkkeihin.

---

## 2. Mitä Gemin tulee kerätä käyttäjältä (tarkentavat kysymykset)

Ennen tiedostojen generointia Gem varmistaa vähintään nämä (kysy **1–2 kysymystä per viesti**):

0. **Projektin nimi** — lyhyt nimi dokumentteihin (ei mallipohjan repo-nimeä).
1. **Kohdekäyttäjät** — käyttäjän kuvaamat roolit (ei valmiita oletuksia ohjeista).
2. **Käyttötilanne** — laite, paikka, offline-tarve käyttäjän sanoin.
3. **MVP-laajuus** — 3–5 pakollista ominaisuutta käyttäjän tavoitteiden mukaan.
4. **Datan ydin** — käyttäjän kuvaamat entiteetit ja tallennustapa.
5. **Totuudenlähde** — tallennus (JSON-tiedosto, SQLite, pilvi-API)?
6. **Teknologiatoive** — web (HTML/JS), Python-automaatio, React tms.?
7. **Julkaisu** — vain paikallinen, Vercel-web, Docker-backend?
8. **Kieli ja saavutettavuus** — UI-kieli, WCAG-tarve?
9. **Tietosuoja** — henkilötiedot, GDPR, vain paikallinen käsittely (Gemma)?

Kun nämä ovat riittävän selvät, Gem tekee **lyhyen MVP-yhteenvedon** ja pyytää vahvistuksen ennen tiedostojen tulostusta.

---

## 3. Gemin tuottamat tiedostot (mallipohjan rakenne)

| Tiedosto | Rooli |
|----------|--------|
| `agents.md` | **Tämän projektin** perustuslaki (käyttäjän projektin nimi visiossa): pino, data, skillit, muististrategia. |
| `task_plan.md` | Korkean tason roadmap (virstanpylväät, ei päivittäisiä mikrotehtäviä). |
| `directives/current_task.md` | **Yksi** ensimmäinen konkreettinen tehtävä agentille. |
| `data/schema.json` | JSON-skeema (Data-First) — jos projekti on datalähtöinen. |
| `docs/parking_lot.md` | Lisäykset, jotka eivät kuulu MVP:hen (valinnainen päivitys). |
| `.env.example` | **Vain muuttujanimet ja kommentit** — ei oikeita arvoja. |

**Ei tuoteta:** `progress.md` / `findings.md` (agentti täyttää itse). **Ei sekoiteta:** the agent's sisäistä `task.md` (brain) vs `task_plan.md` (repo).

---

## 4. Asennus Gemiin (käyttäjälle)

**Seikkaperäinen ohje:** [gem_asennusohje.md](gem_asennusohje.md) (mitä tallennetaan Gemiin vs paikalliseen työtilaan).

**Pikayhteenveto:**

1. **Gemini → Gems → Luo uusi Gem**
2. **Nimi:** esim. `Projektikäynnistys (mallipohja)` (ei mallipohjan repo-nimeä)
3. **Instructions:** kopioi koko [`gem_custom_instructions_paste.txt`](gem_custom_instructions_paste.txt)
4. **Knowledge:** lataa `agents.md`, `directives/prompt_template.md`, `BEFORE_YOU_START.md` (valinn. `docs/gem_workspace_kickstart.md`)
5. **Älä lataa:** `.env`, `data/*.xlsx`, salaisuuksia
6. **Save** → testaa Preview-idealla
7. Gemin tulosteet → kopioi **uuden** `workspace-[projekti]/` -kansion tiedostoihin

---

## 5. Käyttö käyttäjän näkökulmasta

```
Sinä: [oma projekti-ideas, 1–3 lausetta]
Gem: [1–2 tarkentavaa kysymystä]
Sinä: [vastaukset]
Gem: [ehdotukset MVP + parking lot -lisäykset]
Sinä: Hyväksy / muokkaa
Gem: [koodilohkot: agents.md, task_plan.md, current_task.md, ...]
Sinä: Kopioi sisällöt työtilaan → anna the agent: "Lue agents.md ja directives/current_task.md, aloita."
```

---

## 6. Token-säästö in the agent (Gem → agentti)

Gem tekee **suunnittelun**; your AI coding agent (e.g. Cursor) tekee **toteutuksen**. Ohjeista käyttäjää:

- Viittaamaan tiedostoihin `@agents.md` ja `@directives/current_task.md`.
- Yksi tehtävä kerrallaan `current_task.md`:ssä.
- Massadata / arkaluonteinen → paikallinen Gemma (`gemma_bridge`).

---

*Päivitetty: mallipohja-työtilan Gem-ohje.*
