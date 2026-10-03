#!/usr/bin/env python3
"""
MALLIPOHJA: Verkkosivujen tiedonhaku (Web Scraper)
Tämä skripti on valmis pohja tietojen hakemiseen julkisilta verkkosivuilta.
Se sisältää virheenkorjauksen, logging-järjestelmän ja tallentaa tulokset data/ -kansioon.
"""

import os
import json
import logging
from datetime import datetime
import requests
from bs4 import BeautifulSoup
from dotenv import load_dotenv

# Ladataan .env-tiedosto jos sellainen on olemassa (API-avaimille tms.)
load_dotenv()

# Konfiguroidaan lokitus (logging)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler(
            os.path.join(os.path.dirname(__file__), '../../logs/runtime/scraper.log'),
            encoding='utf-8',
        )
    ]
)

# Standardi User-Agent estämään turhat estot verkkosivuilta
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

def scrape_website(url):
    """
    Hakee annetun URL-osoitteen HTML-sisällön ja parsii siitä halutut tiedot.
    """
    logging.info(f"Aloitetaan haku osoitteesta: {url}")
    
    try:
        response = requests.get(url, headers=HEADERS, timeout=10)
        # Nousee virhe jos HTTP-statuskoodi on 4xx tai 5xx
        response.raise_for_status() 
        
    except requests.exceptions.RequestException as e:
        logging.error(f"Virhe sivun hakemisessa: {e}")
        return None

    # Parsitaan HTML BeautifulSoupilla
    soup = BeautifulSoup(response.text, 'html.parser')
    
    # --- MOKKI-LOGIIKKA (Korvaa tämä omilla valitsimillasi) ---
    # Tässä haetaan esimerkin vuoksi sivun otsikko ja kaikki linkit
    scraped_data = {
        "title": soup.title.string.strip() if soup.title else "Ei otsikkoa",
        "url": url,
        "scraped_at": datetime.now().isoformat(),
        "links": []
    }
    
    # Etsitään esimerkiksi ensimmäiset 10 linkkiä
    links = soup.find_all('a', href=True, limit=10)
    for link in links:
        scraped_data["links"].append({
            "text": link.text.strip() or "Tyhjä teksti",
            "href": link['href']
        })
        
    logging.info(f"Haku onnistui. Löydettiin {len(scraped_data['links'])} linkkiä.")
    return scraped_data

def save_results(data, filename="scraped_results.json"):
    """
    Tallentaa parsitut tiedot data/ -kansioon.
    """
    # Varmistetaan että data-kansio on olemassa
    data_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../data'))
    os.makedirs(data_dir, exist_ok=True)
    
    output_path = os.path.join(data_dir, filename)
    
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        logging.info(f"Tulokset tallennettu onnistuneesti tiedostoon: {output_path}")
        return True
    except IOError as e:
        logging.error(f"Virhe tiedoston tallentamisessa: {e}")
        return False

if __name__ == "__main__":
    # Esimerkki-ajo Wikipedian etusivulla
    target_url = "https://fi.wikipedia.org/wiki/Wikipedia:Etusivu"
    result = scrape_website(target_url)
    
    if result:
        save_results(result, "wikipedia_scraped.json")
    else:
        logging.error("Skreippaus epäonnistui.")
