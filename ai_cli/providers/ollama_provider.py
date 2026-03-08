import requests
from ..config import MODEL, OLLAMA_URL


def query_ollama(prompt):

    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False
    }

    try:
        r = requests.post(OLLAMA_URL, json=payload, timeout=30)
        
        if r.status_code == 200:
            return r.json()["response"]
        elif r.status_code == 404:
            return f"Ollama Error: Model '{MODEL}' not found. Please run 'ollama pull {MODEL}' first."
        else:
            return f"Ollama request failed with status {r.status_code}: {r.text}"
            
    except requests.exceptions.ConnectionError:
        return "Ollama Error: Could not connect to the Ollama service. Is 'ollama serve' running?"
    except Exception as e:
        return f"Ollama Error: {str(e)}"
