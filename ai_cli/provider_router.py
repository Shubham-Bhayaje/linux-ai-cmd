from .config import PROVIDER
from .providers.ollama_provider import query_ollama
from .providers.openai_provider import query_openai
from .providers.claude_provider import query_claude


def query_model(prompt):

    if PROVIDER == "ollama":
        return query_ollama(prompt)

    elif PROVIDER == "openai":
        return query_openai(prompt)

    elif PROVIDER == "claude":
        return query_claude(prompt)

    else:
        return "Provider not configured"
