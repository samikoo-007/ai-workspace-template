---
name: Database & ORM (Tietokannat ja Datanhallinta)
description: Käytä tätä taitoa lokaalien tietokantojen (esim. SQLite, JSON, CSV) ja ORM-työkalujen (esim. Prisma, SQLAlchemy) suunnitteluun ja hallintaan.
---

# Database & ORM Skill

Tämän taidon tarkoituksena on hallinnoida datamalleja, paikallisia tietokantoja ja ORM-työkaluja turvallisesti ja skaalautuvasti. **HUOM:** Työtilassa painotetaan lokaalia kehitystä ja lokaaleja tiedostoja, joten vältä ulkoisten SQL-palvelimien pystyttämistä, ellei toisin vaadita.

## Suoritusohjeet:
1. **Datalähtöinen suunnittelu (Data-First):** Ennen koodin kirjoittamista, määritä tietomallit ja JSON-skeemat (tai Prisma/SQLAlchemy-mallit) ensin.
2. **Käytä lokaalia tallennusta:**
   - Suosi `SQLite` -tietokantaa lokaalissa kehityksessä, jos tarvitaan relaatiotietokantaa.
   - Pienempiin tarpeisiin käytä `JSON`-tiedostoja tai CSV-tiedostoja, jotka tallennetaan `data/` -kansioon.
3. **ORM-työkalut:** Käytä työtilaan parhaiten sopivaa työkalua:
   - Node.js: `Prisma` tai `Drizzle ORM` (käyttäen sqlite-adapteria).
   - Python: `SQLAlchemy` tai `Peewee` (SQLite).
4. **Migraatiot:** Jos teet muutoksia skeemaan, huolehdi migraatiotiedostojen luomisesta asianmukaisesti.
5. **Turvallisuus:** Varmista, ettei SQL-injektioita voi tapahtua (käytä aina parametrisoituja kyselyitä tai luotettavaa ORM:ää).
