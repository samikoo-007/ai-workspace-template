# Gemini Gem — seikkaperäinen asennus- ja tallennusohje

Tämä ohje kertoo **mitä** tallennat, **mihin** (Gem vs paikallinen työtila) ja **mitä et saa** laittaa Gemiin.

> **Mallipohjan jakokansio:** käytä tiedostopolkuja **tästä julkisesta mallipohjasta** (tai Template-kloonista). Älä syötä Gemiin henkilökohtaista kehityshaaraa, ellei se ole synkronoitu puhtaaseen pohjaan.

---

## Kaksi eri “tallennuspaikkaa” (älä sekoita)

| Paikka | Mitä sinne kuuluu | Kuka ylläpitää |
|--------|-------------------|----------------|
| **Gemini Gem (pilvi)** | Gemin ohjeet + Knowledge-tiedostot (mallipohjan säännöt) | Sinä, Gem Managerissa |
| **Paikallinen työtila** (`workspace-[projekti]/`) | Gemin **generoimat** projektikohtaiset tiedostot | Sinä kopioit Gemin vastauksesta; agentti täyttää lokit |

Gem **ei korvaa** työtilaa — se valmistelee uuden projektin dokumentit. Toteutus tapahtuu your AI coding agent.

---

## Osa 1: Gemin luonti (gemini.google.com)

### Vaihe 1 — Avaa Gem Manager

1. Avaa selaimessa [gemini.google.com](https://gemini.google.com).
2. Vasemmalta valitse **Gems** (tai **Gem Manager**).
3. Valitse **Create new Gem** / **Luo uusi Gem**.

> UI voi hieman vaihdella tilauksen (Advanced / Business) mukaan. Knowledge-tiedostot vaativat usein Gemini Advanced -tasoa tai työtilatilin ominaisuuden — jos “Knowledge”-osiota ei näy, päivitä tilaus tai käytä vain Custom Instructions -kenttää.

### Vaihe 2 — Perustiedot (nimi ja kuvaus)

| Kenttä Gemissä | Mitä kirjoitat | Esimerkki |
|----------------|----------------|-----------|
| **Name / Nimi** | Gemin tunnistettava nimi (ei projektin nimi) | `Projektikäynnistys – mallipohja` |
| **Description / Kuvaus** (valinnainen) | Yksi lause käyttäjälle itsellesi | `Muuttaa projekti-idean workspace-tiedostoiksi.` |

**Älä** nimeä Gemiä mallipohjan repo-nimellä — se on mallipohja, ei Gemin nimi eikä käyttäjän projekti.

### Vaihe 3 — Custom Instructions (pakollinen)

| Mihin | Mitä |
|-------|------|
| Kenttä: **Instructions** / **Custom instructions** / **Ohjeet** | Koko tiedoston sisältö |

**Lähde tiedosto työtilassasi:**

```
docs/gem_custom_instructions_paste.txt
```

**Toimenpide:**

1. Avaa tiedosto editorissa.
2. Valitse kaikki (Cmd+A) ja kopioi.
3. Liitä Gemin Instructions-kenttään.
4. Älä lyhennä — kriittiset säännöt (projektityypit, ei mallipohjan nimeä projektiksi, ei salaisuuksia) ovat siellä.

Kun päivität ohjeita myöhemmin, **korvaa koko Instructions-kentän sisältö** uudella paste-tiedostolla ja tallenna Gem uudelleen.

### Vaihe 4 — Knowledge (suositeltu, max ~10 tiedostoa)

Scrollaa Instructions-kentän alle → osio **Knowledge** → **Add files** / **Lisää tiedostoja**.

Lataa **mallipohjan juuresta** (ei henkilökohtaista kehityskopiota, ei koko Drivea):

| # | Tiedosto (polku repossa) | Miksi Gem tarvitsee sen |
|---|--------------------------|-------------------------|
| 1 | `agents.md` (juuri) | Mallipohjan perustuslaki: kansiorakenne, Data-First, token-säästö, Gemma |
| 2 | `directives/prompt_template.md` | `current_task.md`:n oikea rakenne |
| 3 | `BEFORE_YOU_START.md` (juuri) | Tehtävälistojen erot, tietoturva, `.env` vs `mcp_config` |
| 4 | `docs/gem_workspace_kickstart.md` | Gem-käyttö ja projektityypit (valinnainen mutta hyödyllinen) |

**Valinnainen** (jos Knowledge-slottia on vapaana):

| Tiedosto | Milloin |
|----------|---------|
| `README.md` | Käynnistyspolku ihmiselle ja agentille |
| `directives/current_task.md` | Tyhjä pohja — vain jos haluat Gemin näkevän nykyisen mallin |
| `.env.example` | Muuttujien *nimet* (ei `.env`!) |

**Knowledge-yhteensä:** pidä mieluummin **4–5 pientä .md-tiedostoa** kuin yksi jättitiedosto — helpompi RAG-haku.

**Google Drive -linkitys:** Jos lisäät tiedoston Drivestä, Gem käyttää **uusinta versiota** Docs/Sheets-tiedostoille. Paikalliset .md-tiedostot: päivitä Gemiin uudelleen uploadilla, kun muutat niitä repossa.

### Vaihe 5 — Knowledge-asetukset

- **Disable knowledge citations:** voit jättää päälle (näet mistä kohta ohje tuli) tai pois, jos haluat siistimmän vastauksen.
- **Älä lataa** koko projektin `data/*.xlsx` Gemin Knowledgeen — ne ovat projektikohtaisia ja voivat sisältää PII:tä.

### Vaihe 6 — Esikatselu ja tallennus

1. Käytä **Preview**-ikkunaa: anna testi-idea yhdellä lauseella.
2. Tarkista: Gem kysyy **projektin nimeä** ja **projektityyppiä**, ei mainitse mallipohjan repo-nimeä projektin nimenä.
3. Paina **Save** / **Tallenna**.

Gemin asetukset tallentuvat **Google-tilillesi** (Gems-lista), ei paikalliseen repoon.

---

## Osa 2: Mitä EI tallenneta Gemiin

| Älä lataa / älä liitä | Syy |
|----------------------|-----|
| `.env` (oikeat avaimet) | Salaisuudet |
| `mcp_config.json` avaimilla | Sama |
| `data/*.xlsx`, CSV raakadatalla | PII, koko, projektikohtainen — käytä paikallista agenttia / Gemmaa |
| `temp/` | Väliaikainen, Drive-synkka-riski |
| Koko repo zip-pakettina | Token-hävikki, vanhentunut knowledge |
| Projektin valmiit `agents.md` eri projekteista | Sekoittaa uuden projektin generoinnin |

---

## Osa 3: Gemin käyttö → mitä tallennetaan paikalliseen työtilaan

Kun Gem on valmis ja olet keskustelussa:

### Sinä annat (vain chattiin, ei Gem-asetuksiin)

```
[Projekti-ideas 1–3 lausetta]
```

Esim. data-projekti: *"Muunna data-kansion Excel-tiedostot JSON-muotoon analyysiä varten."*

### Gem tuottaa (kopioit vastauksesta)

Jokainen lohko on muotoa `<!-- FILE: polku -->` + markdown. Kopioi **uuden projektin** kansioon:

| Gemin lohko | Tallenna paikallisesti tiedostoon |
|-------------|-----------------------------------|
| `FILE: agents.md` | `[projektin juuri]/agents.md` |
| `FILE: task_plan.md` | `[projektin juuri]/task_plan.md` |
| `FILE: directives/current_task.md` | `[projektin juuri]/directives/current_task.md` |
| `FILE: data/schema.json` | `[projektin juuri]/data/schema.json` |
| `FILE: .env.example` | yhdistä olemassa olevaan tai korvaa vain uudet rivit |
| `FILE: docs/parking_lot.md` | `[projektin juuri]/docs/parking_lot.md` |

**Ennen ensimmäistä agenttikäskyä paikallisesti:**

1. Kopioi mallipohja kansioon `workspace-[lyhyt-nimi]` (esim. `workspace-excel-muunnos`).
2. Korvaa/ täytä yllä olevat tiedostot Gemin tulosteilla.
3. Kopioi `.env.example` → `.env` ja täytä arvot **vain paikallisesti**.
4. Laita Excel-tiedostot **`data/`**-kansioon (ei Gemiin).
5. Anna agentille: `Lue agents.md ja directives/current_task.md, aloita tehtävä.`

### Mitä agentti täyttää (sinä et kopioi Gemistä)

| Tiedosto | Rooli |
|----------|--------|
| `progress.md` | Valmistumisloki |
| `findings.md` | Oppiminen virheistä |
| `scripts/`, `tests/` | Toteutuksen koodi |

---

## Osa 4: Päivitys kun muutat mallipohjaa

| Muutit | Toimi |
|--------|--------|
| `docs/gem_custom_instructions_paste.txt` | Päivitä Gemin **Instructions** (koko kenttä) → Save |
| `agents.md`, `BEFORE_YOU_START.md`, jne. | Poista vanha Knowledge-tiedosto Gemistä → lataa uusi versio |
| Uusi projektityyppi / sääntö | Testaa samalla testi-idealla Previewissä |

---

## Osa 5: Pikachecklist

**Gemiin (kerran / päivityksen yhteydessä):**

- [ ] Instructions = koko `gem_custom_instructions_paste.txt`
- [ ] Knowledge: `agents.md`, `prompt_template.md`, `BEFORE_YOU_START.md`
- [ ] Ei `.env`, ei `data/*.xlsx`
- [ ] Preview-testi: Gem kysyy projektin nimeä, ei sekoita mallipohjaa projektiin

**Uuteen projektiin (jokainen idea):**

- [ ] Kopioi mallipohja → `workspace-[nimi]`
- [ ] Liitä Gemin tulosteet `agents.md`, `task_plan.md`, `current_task.md`, …
- [ ] `.env` paikallisesti
- [ ] Data `data/` → agentti toteuttaa

---

## Linkit

- [Google: Use Gems in Gemini Apps](https://support.google.com/gemini/answer/15146780)
- [Google: Upload files in Gemini](https://support.google.com/gemini/answer/14903178)
- Työtilan paste-ohje: `docs/gem_custom_instructions_paste.txt`
- Gem-käyttö: `docs/gem_workspace_kickstart.md`
