# AI CLI v4

A cross-platform AI-powered CLI assistant for system administration. Works on **Linux** and **Windows** — automatically detects your OS and gives platform-specific answers.

Supports **Ollama**, **OpenAI**, and **Claude** as AI providers.

## Features

| Command              | Description                        |
| -------------------- | ---------------------------------- |
| `ai ask "..."`       | Ask AI anything about your system  |
| `ai explain "..."`   | Explain a command with examples    |
| `ai fix "..."`       | Get help fixing an error           |
| `ai fix -`           | Fix an error piped from `stdin`    |
| `ai fixcmd "..."`    | Run cmd and fix if it errors       |
| `ai cmd "..."`       | Generate a command for a task      |
| `ai run "..."`       | Generate and optionally run a cmd  |
| `ai analyze <file>`  | Analyze a log file                 |
| `ai cpu`             | Diagnose CPU usage                 |
| `ai memory`          | Diagnose memory usage              |
| `ai disk`            | Diagnose disk usage                |
| `ai service <name>`  | Diagnose a service                 |

## System Diagnostics

| Command            | Linux              | Windows                          |
| ------------------ | ------------------ | -------------------------------- |
| `ai cpu`           | `top` + `ps`       | `Get-Process` + WMI              |
| `ai memory`        | `free` + `vmstat`   | `Get-Process` + WMI              |
| `ai disk`          | `df` + `du`         | `Get-PSDrive` + WMI              |
| `ai service nginx` | `systemctl` + `journalctl` | `Get-Service` + `Get-WinEvent` |
| `ai analyze`       | Log file contents   | Log file contents                |

## Installation

### Linux / WSL / macOS

```bash
curl -sL https://raw.githubusercontent.com/Shubham-Bhayaje/linux-ai-cmd/main/install.sh | bash
```

### Windows

1. Make sure Python 3 and Git are installed
2. Download or clone this repo
3. Run:
```cmd
install.bat
```

The installer will prompt you to choose between **Ollama**, **OpenAI**, or **Claude**.

## Configuration

Edit `ai_cli/config.py` (Linux: `/etc/linux-ai-cli/config.py`, Windows: `%USERPROFILE%\.ai-cli\config.py`):

```python
PROVIDER = "ollama"   # ollama | openai | claude
MODEL = "phi3"

OLLAMA_URL = "http://localhost:11434/api/generate"
OPENAI_API_KEY = ""
CLAUDE_API_KEY = ""
```

## Uninstall

### Linux
```bash
curl -sL https://raw.githubusercontent.com/Shubham-Bhayaje/linux-ai-cmd/main/uninstall.sh | bash
```

### Windows
```cmd
rmdir /s /q %USERPROFILE%\ai-cli
del %USERPROFILE%\AppData\Local\Microsoft\WindowsApps\ai.bat
```

## Requirements

- Python 3.8+
- `requests`, `rich`, `typer`
