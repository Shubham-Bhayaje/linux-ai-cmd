import requests
from ..config import OPENAI_API_KEY


def query_openai(prompt):

    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "Content-Type": "application/json"
    }

    data = {
        "model": "gpt-4o-mini",
        "messages": [{"role": "user", "content": prompt}]
    }

    try:
        r = requests.post(
            "https://api.openai.com/v1/chat/completions",
            headers=headers,
            json=data,
            timeout=300
        )

        if r.status_code == 200:
            return r.json()["choices"][0]["message"]["content"]
        
        return f"OpenAI request failed with status {r.status_code}: {r.text}"
        
    except Exception as e:
        return f"OpenAI Error: {str(e)}"
