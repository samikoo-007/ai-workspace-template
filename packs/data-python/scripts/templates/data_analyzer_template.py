#!/usr/bin/env python3
"""
MALLIPOHJA: Datan analysointi (Data Analyzer)
Tämä skripti toimii valmiina pohjana taulukkomuotoisen datan (CSV/JSON/Excel)
käsittelyyn ja analysointiin Pandas-kirjaston avulla.
"""

import os
import pandas as pd
import json
import logging

_LOG_DIR = os.path.join(os.path.dirname(__file__), '../../logs/runtime')
os.makedirs(_LOG_DIR, exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler(os.path.join(_LOG_DIR, 'data_analyzer.log'), encoding='utf-8'),
    ],
)

def create_mock_data():
    """
    Luo mock-datan testitarkoituksiin, jos oikeaa dataa ei ole vielä ladattu.
    """
    mock_records = [
        {"Tuote": "A", "Kategoria": "Elektroniikka", "Myynti": 1200, "Määrä": 4},
        {"Tuote": "B", "Kategoria": "Elektroniikka", "Myynti": 800, "Määrä": 2},
        {"Tuote": "C", "Kategoria": "Vaatteet", "Myynti": 450, "Määrä": 3},
        {"Tuote": "D", "Kategoria": "Vaatteet", "Myynti": 150, "Määrä": 1},
        {"Tuote": "E", "Kategoria": "Kirjat", "Myynti": 300, "Määrä": 6},
        {"Tuote": "F", "Kategoria": "Kirjat", "Myynti": 120, "Määrä": 2}
    ]
    return pd.DataFrame(mock_records)

def analyze_data(df):
    """
    Suorittaa analyysin annetulle DataFrame-objektille.
    """
    logging.info("Aloitetaan datan analysointi...")
    
    # 1. Perustiedot datasta
    logging.info(f"Datarivejä: {len(df)}, Sarakkeita: {list(df.columns)}")
    
    # 2. Ryhmittely (esim. Myynnin summa per Kategoria)
    myynti_kategorioittain = df.groupby("Kategoria")["Myynti"].sum().reset_index()
    logging.info("\nMyynti kategorioittain:\n" + str(myynti_kategorioittain))
    
    # 3. Keskimääräinen yksikköhinta (Myynti / Määrä)
    df["Yksikköhinta"] = df["Myynti"] / df["Määrä"]
    
    # 4. Suodatetaan suuret myynnit (esim. yli 400€)
    suuret_myynnit = df[df["Myynti"] > 400]
    
    analysis_results = {
        "summary": df.describe(include='all').to_dict(),
        "sales_by_category": myynti_kategorioittain.to_dict(orient="records"),
        "high_value_sales": suuret_myynnit.to_dict(orient="records")
    }
    
    return analysis_results

def save_report(results, df_processed, report_name="myyntianalyysi"):
    """
    Tallentaa analyysin tulokset Excel/CSV-muodossa ja JSON-raporttina data-kansioon.
    """
    data_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../data'))
    os.makedirs(data_dir, exist_ok=True)
    
    # 1. Tallennetaan prosessoitu data CSV-tiedostoksi
    csv_path = os.path.join(data_dir, f"{report_name}_processed.csv")
    df_processed.to_csv(csv_path, index=False, encoding='utf-8-sig')
    logging.info(f"Käsitelty data tallennettu CSV-tiedostoon: {csv_path}")
    
    # 2. Tallennetaan analyysitulokset JSON-raporttina
    json_path = os.path.join(data_dir, f"{report_name}_report.json")
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(results, f, ensure_ascii=False, indent=2)
    logging.info(f"Analyysiraportti tallennettu JSON-tiedostoon: {json_path}")

if __name__ == "__main__":
    # Esimerkki-ajo mock-datalla
    df = create_mock_data()
    
    # Suoritetaan analyysi
    results = analyze_data(df)
    
    # Tallennetaan raportit
    save_report(results, df, "esimerkki_myynti")
