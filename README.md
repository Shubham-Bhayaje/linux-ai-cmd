# Linux AI CLI v3

A DevOps AI troubleshooting assistant for Linux systems. Ask AI questions, explain commands, fix errors, generate commands, analyze logs, and diagnose system issues — all from the terminal.

Supports **Ollama**, **OpenAI**, and **Claude** as AI providers.

## Features

| Command              | Description                        |
| -------------------- | ---------------------------------- |
| `ai ask "..."`       | Ask AI anything                    |
| `ai explain "..."`   | Explain a Linux command            |
| `ai fix "..."`       | Get help fixing an error           |
| `ai cmd "..."`       | Generate a Linux command           |
| `ai run "..."`       | Generate and optionally run a cmd  |
| `ai analyze <file>`  | Analyze a log file                 |
| `ai cpu`             | Diagnose CPU usage                 |
| `ai memory`          | Diagnose memory usage              |
| `ai disk`            | Diagnose disk usage                |
| `ai service <name>`  | Diagnose a systemd service         |

## System Diagnostics

| Command            | What it inspects     |
| ------------------ | -------------------- |
| `ai cpu`           | `top` + `ps`         |
| `ai memory`        | `free` + `vmstat`    |
| `ai disk`          | `df` + `du`          |
| `ai service nginx` | `systemctl` + `journalctl` |
| `ai analyze`       | Log file contents    |

## Installation

```bash
bash install.sh
```

## Configuration

Edit `ai_cli/config.py` to set your provider and API keys:

```python
PROVIDER = "ollama"   # ollama | openai | claude
MODEL = "phi3"

OLLAMA_URL = "http://localhost:11434/api/generate"
OPENAI_API_KEY = ""
CLAUDE_API_KEY = ""
```

## Uninstall

```bash
bash uninstall.sh
```

## Requirements

- Python 3
- `requests`, `rich`, `typer`
