import requests
from ..config import MODEL, OLLAMA_URL


def query_ollama(prompt):

    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False
    }

    r = requests.post(OLLAMA_URL, json=payload)

    if r.status_code == 200:
        return r.json()["response"]

    return "Ollama request failed"
