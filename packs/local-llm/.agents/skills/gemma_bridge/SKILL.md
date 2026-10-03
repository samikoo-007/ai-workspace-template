---
name: gemma_bridge
description: "Tämä taito mahdollistaa tehtävien delegoinnin paikalliselle Gemma 4 LLM:lle (Ollama). Käytä tätä AINA, kun käyttäjä mainitsee 'Gemma' tai 'Gemma4'."
---

# Skill: Gemma Bridge (Paikallisen LLM:n delegaatio)

Tämä taito mahdollistaa tehtävien delegoinnin lokaalille Ollama-palvelimelle (esim. Gemma 4 -mallille).

## ⚠️ Milloin tätä taitoa tulee käyttää (Triggerit)?
Käytä tätä taitoa ja siihen liittyvää Python-skriptiä **välittömästi**, kun:
1. Käyttäjä mainitsee pyynnössään sanan **"Gemma"** tai **"Gemma4"** (tämä on eksplisiittinen pyyntö käyttää paikallista mallia).
2. Tehtävänä on **massadata-analyysi**: Kymmenien tai satojen kilotavujen analysointi, joka ylittäisi pääagentin oman token-rajan tai konteksti-ikkunan.
3. Tehtävänä on **tietosuojaa** vaativa tehtävä: Asiakirjat tai data, jota ei haluta lähettää pilveen analysoitavaksi.

## Komento (Execution)

Taito suoritetaan `.agents/skills/gemma_bridge/gemma_delegate.py` -skriptin avulla. Skripti on suunniteltu agentin käyttöön ja se tukee useita älykkäitä ominaisuuksia.

### 1. Peruskäyttö (Lyhyet kehotteet)
```bash
python3 .agents/skills/gemma_bridge/gemma_delegate.py "Kehotteesi tähän"
```

### 2. Tiedostopohjainen syöte (Massadata - SUOSITELTU)
Jos lähetät mallille paljon tekstiä (esim. tiedoston sisältö, pitkät logit, koodikanta), tallenna kehote ja data ensin väliaikaistiedostoon ja lue se sisään `--file` parametrilla. Tämä estää Bash-komennon pituusrajojen rikkoutumisen:
```bash
# Luo ensin tiedosto (esim. prompt.txt), jossa on ohjeet + data
python3 .agents/skills/gemma_bridge/gemma_delegate.py --file prompt.txt
```

### 3. Rakenteellisen datan pakotus (JSON)
Jos haluat, että lokaali malli palauttaa datan automaattisesti purettavassa muodossa, ohjeista kehote palauttamaan JSON ja käytä `--json` -lippua:
```bash
python3 .agents/skills/gemma_bridge/gemma_delegate.py --json "Tee analyysi ja palauta vastaus yksinomaan validina JSON-muotona..."
```

*(Voit yhdistää komentoja: `python3 ... --json --file prompt.txt`)*

## Konfiguraatio ja Kehotteiden Parhaat Käytännöt (Agentille ja Kehittäjälle)

- **API URL**: Oletuksena `http://localhost:11434/api/generate`.
- **Malli**: Oletuksena `gemma4`.
- **Ohjeistus (Prompting)**: Koska lokaalit mallit voivat olla rajallisempia, ole erittäin tarkka. Anna mallille selkeä rooli ja kerro sille tarkasti, missä muodossa haluat vastauksen (esim. *"Vastaa vain listana"*, *"Palauta tulos JSON-muodossa ilman mitään muuta tekstiä"*).
- **Virhetilanteet**: Skriptissä on sisäänrakennettu timeout ja error handling. Jos skripti palauttaa verkkoyhteysvirheen, kommunikoi ihmiskäyttäjälle selkeästi, että "Paikalliseen Ollama-palvelimeen ei saatu yhteyttä tai se ei vastannut ajoissa. Varmistathan, että Ollama on käynnissä koneellasi".
