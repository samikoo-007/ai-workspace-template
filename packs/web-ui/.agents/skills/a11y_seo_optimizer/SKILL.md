---
name: A11y & SEO Optimizer (Saavutettavuus ja SEO)
description: Käytä tätä taitoa varmistamaan verkkosivuston WCAG-saavutettavuus sekä teknisen hakukoneoptimoinnin (SEO) parhaat käytännöt.
---

# A11y & SEO Optimizer Skill

Hyvä käyttöliittymä (UI) ei riitä, jos sovellus ei ole hakukoneystävällinen tai sitä ei voi käyttää apuvälineillä. Tällä taidolla varmistetaan korkea laatu selaimeen päätyvälle koodille.

## Suoritusohjeet saavutettavuuteen (A11y):
1. **Semanttinen HTML:** Varmista, että napit ovat `<button>`, linkit `<a>`, ja otsikot noudattavat oikeaa hierarkiaa (`<h1>` -> `<h2>` -> `<h3>`).
2. **Aria-attribuutit:** Lisää `aria-label`, `aria-hidden` ja `role` attribuutit sinne missä niitä tarvitaan, erityisesti dynaamisissa komponenteissa (esim. modaalit, pudotusvalikot).
3. **Kontrastit ja Näppäimistö:** Varmista riittävä värikontrasti ja navigointi. Elementtien focus-tilan (`:focus-visible`) pitää erottua selkeästi näppäimistöllä navigoiville.

## Suoritusohjeet SEO:hon:
1. **Metatiedot:** Jokaisella sivulla on oltava oikeat `<title>` ja `<meta name="description">`.
2. **Open Graph:** Paranna jaon näkyvyyttä (esim. Some-kanavissa) lisäämällä `og:title`, `og:image` ja `og:description` metatagit.
3. **Suorituskyky (Core Web Vitals):** Käytä optimoituja kuvia (WebP/AVIF) ja vältä raskaiden skriptien lataamista renderöinnin esteenä.
4. **Otsikkohierarkia:** Varmista, että sivulla on ainoastaan yksi looginen `<h1>` otsikko.
