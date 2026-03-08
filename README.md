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

#### Prerequisites

1. **Install Python 3.8+** from [python.org/downloads](https://www.python.org/downloads/)
   - ⚠️ During installation, check **"Add Python to PATH"** — this is critical!
   - To verify: open Command Prompt and run `python --version`

2. **Install Git** from [git-scm.com](https://git-scm.com/)
   - To verify: open Command Prompt and run `git --version`

#### Step-by-Step Setup

**Step 1:** Open **Command Prompt** or **PowerShell** and clone the repo:
```cmd
git clone https://github.com/Shubham-Bhayaje/linux-ai-cmd.git %USERPROFILE%\ai-cli
```

**Step 2:** Run the installer:
```cmd
cd %USERPROFILE%\ai-cli
install.bat
```

**Step 3:** The installer will:
- ✅ Install Python dependencies (`requests`, `rich`, `typer`)
- ✅ Ask you to choose an AI provider (Ollama / OpenAI / Claude)
- ✅ Save your API key in `%USERPROFILE%\.ai-cli\config.py`
- ✅ Add the `ai` command to your PATH

**Step 4:** **Open a new terminal** (important — PATH changes need a fresh window)

**Step 5:** Verify it works:
```cmd
ai --help
ai ask "hello, what OS am I running?"
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
