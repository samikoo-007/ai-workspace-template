---
name: API Development (API-integraatiot ja rajapinnat)
description: Käytä tätä taitoa RESTful- tai GraphQL-rajapintojen rakentamiseen, dokumentointiin, sekä ulkoisten rajapintojen turvalliseen kutsumiseen.
---

# API Development Skill

Tämän taidon tavoitteena on varmistaa, että kaikki rajapinnat rakennetaan ja kulutetaan turvallisesti, modulaarisesti ja yhdenmukaisesti.

## Suoritusohjeet:
1. **Reittien rakenne (Routing):** Pidä reititykset selkeinä ja modulaarisina (esim. Next.js App Router API -reitit tai Python FastAPI reitit omissa tiedostoissaan).
2. **Ulkopuolisten API:en kutsut:**
   - Kaikki API-avaimet luetaan **AINA** ympäristömuuttujista (`.env`). Älä koskaan kovakoodaa niitä.
   - Käytä virheenkäsittelyä (`try/catch` tai vastaava), jotta sovellus ei kaadu ulkoisen rajapinnan virheeseen tai timeoutiin.
3. **Dokumentointi:** Jos luot uuden rajapinnan, kirjoita sen Request/Response -skeemat selkeästi näkyviin koodin kommentteihin tai erilliseen markdown-tiedostoon.
4. **Virhevastaukset (Error Responses):** Palauta aina selkeät ja yhtenäiset JSON-virheilmoitukset (esim. `{ "error": true, "message": "Syötteen validointi epäonnistui", "code": 400 }`).
5. **Rate Limiting:** Huomioi ratelimitit, jos kutsut kolmannen osapuolen API:eja.
