import requests
from ..config import CLAUDE_API_KEY


def query_claude(prompt):

    headers = {
        "x-api-key": CLAUDE_API_KEY,
        "content-type": "application/json"
    }

    data = {
        "model": "claude-3-haiku-20240307",
        "max_tokens": 1024,
        "messages": [{"role": "user", "content": prompt}]
    }

    r = requests.post(
        "https://api.anthropic.com/v1/messages",
        headers=headers,
        json=data
    )

    if r.status_code == 200:
        return r.json()["content"][0]["text"]

    return "Claude request failed"
