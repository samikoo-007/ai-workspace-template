import requests
import json
import sys
import argparse
import os

OLLAMA_URL = "http://localhost:11434/api/generate"
DEFAULT_MODEL = "gemma4"
TIMEOUT_SECONDS = 120

def query_gemma(prompt, model=DEFAULT_MODEL, force_json=False):
    payload = {
        "model": model,
        "prompt": prompt,
        "stream": False
    }
    
    if force_json:
        payload["format"] = "json"

    try:
        response = requests.post(OLLAMA_URL, json=payload, timeout=TIMEOUT_SECONDS)
        response.raise_for_status()
        return response.json().get("response", "").strip()
    except requests.exceptions.Timeout:
        return "VIRHE: Aikakatkaisu. Paikallinen Ollama-palvelin ei vastannut 120 sekunnin kuluessa. Tarkista mallin kuormitus ja varmista, ettei malli ole jumissa."
    except requests.exceptions.ConnectionError:
        return "VIRHE: Yhteysvirhe. Ollama-palvelinta ei löytynyt osoitteesta localhost:11434. Varmista, että Ollama on asennettu ja käynnissä (esim. aja 'ollama serve')."
    except Exception as e:
        return f"VIRHE: Tuntematon virhe tapahtui Ollama-yhteydessä: {str(e)}"

def main():
    parser = argparse.ArgumentParser(description="Delegoi tehtävä lokaalille Gemma LLM:lle (Ollama).")
    parser.add_argument("prompt", nargs="?", default="", help="Kehote tekoälylle (jos et käytä --file).")
    parser.add_argument("--file", "-f", type=str, help="Polku tiedostoon, joka sisältää koko kehotteen ja datan.")
    parser.add_argument("--json", "-j", action="store_true", help="Pakota Ollama palauttamaan validi JSON.")
    parser.add_argument("--model", "-m", type=str, default=DEFAULT_MODEL, help="Käytettävä malli (oletus: gemma4).")

    args = parser.parse_args()

    prompt = args.prompt
    if args.file:
        if not os.path.exists(args.file):
            print(f"VIRHE: Tiedostoa '{args.file}' ei löydy.")
            sys.exit(1)
        with open(args.file, "r", encoding="utf-8") as f:
            prompt = f.read()
    
    if not prompt.strip():
        print("VIRHE: Kehote (prompt) ei voi olla tyhjä. Anna kehote parametrina tai --file avulla.")
        sys.exit(1)

    result = query_gemma(prompt, model=args.model, force_json=args.json)
    print(result)

if __name__ == "__main__":
    main()
