#!/usr/bin/env bash
set -e

echo "========================================="
echo " Installing Linux AI CLI (One-Line Setup)"
echo "========================================="

echo "[1/4] Installing build requirements..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    OS_LIKE=$ID_LIKE
else
    OS=$(uname -s)
fi

if [[ "$OS" == *"ubuntu"* ]] || [[ "$OS" == *"debian"* ]] || [[ "$OS_LIKE" == *"debian"* ]] || [[ "$OS_LIKE" == *"ubuntu"* ]]; then
    sudo apt-get update -y >/dev/null
    sudo apt-get install -y git dpkg-dev curl zstd python3 python3-pip >/dev/null
    PKG_MGR="apt"
elif [[ "$OS" == *"amzn"* ]] || [[ "$OS" == *"centos"* ]] || [[ "$OS" == *"rhel"* ]] || [[ "$OS" == *"fedora"* ]] || [[ "$OS_LIKE" == *"rhel"* ]] || [[ "$OS_LIKE" == *"fedora"* ]] || command -v yum >/dev/null 2>&1; then
    # Amazon Linux / RHEL family
    sudo yum install -y git curl zstd python3 python3-pip >/dev/null 2>&1 || sudo dnf install -y git curl zstd python3 python3-pip >/dev/null 2>&1
    PKG_MGR="yum"
else
    echo "Unsupported OS or Package Manager. Please install git, curl, zstd, and python3 manually."
    exit 1
fi

echo "[2/4] Cloning the repository..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
git clone https://github.com/Shubham-Bhayaje/linux-ai-cmd.git . >/dev/null 2>&1

if [ "$PKG_MGR" = "apt" ]; then
    echo "[3/4] Building the .deb package..."
    chmod +x build-deb.sh
    ./build-deb.sh >/dev/null

    echo "[4/4] Installing package (will prompt for AI Provider)..."
    sudo dpkg -i linux-ai-cli_3.0.0.deb
else
    # Non-Debian systems: Direct install
    echo "[3/4] Installing Python dependencies..."
    sudo pip3 install --break-system-packages requests rich typer 2>/dev/null || sudo pip3 install requests rich typer

    echo "[4/4] Setting up Linux AI CLI..."
    sudo mkdir -p /usr/lib/linux-ai-cli
    sudo cp -r . /usr/lib/linux-ai-cli/
    sudo chmod +x /usr/lib/linux-ai-cli/ai
    sudo ln -sf /usr/lib/linux-ai-cli/ai /usr/local/bin/ai

    sudo mkdir -p /etc/linux-ai-cli
    sudo cp /usr/lib/linux-ai-cli/ai_cli/config.py /etc/linux-ai-cli/config.py
    sudo ln -sf /etc/linux-ai-cli/config.py /usr/lib/linux-ai-cli/ai_cli/config.py
    
    echo ""
    echo "========================================"
    echo "   Linux AI CLI — Setup Wizard v3.0"
    echo "========================================"
    echo ""
    echo "Choose your AI provider:"
    echo "  1) Ollama   — FREE, runs locally (default)"
    echo "  2) OpenAI   — GPT-4o-mini (needs API key)"
    echo "  3) Claude   — Claude 3 Haiku (needs API key)"
    echo ""
    
    # Read from /dev/tty because stdin is piped from curl
    read -p "Select provider [1/2/3] (default: 1): " CHOICE </dev/tty || CHOICE=1
    CHOICE=${CHOICE:-1}

    CONFIG_FILE="/etc/linux-ai-cli/config.py"

    case $CHOICE in
        1)
            echo "Setting up Ollama (local AI)..."
            sudo bash -c "cat > \"$CONFIG_FILE\" <<'EOF'
PROVIDER = \"ollama\"
MODEL = \"phi3\"

OLLAMA_URL = \"http://localhost:11434/api/generate\"

OPENAI_API_KEY = \"\"
CLAUDE_API_KEY = \"\"
EOF"
            if ! command -v ollama >/dev/null 2>&1; then
                echo "Installing Ollama..."
                if curl -fsSL https://ollama.com/install.sh | sh; then
                    echo "Ollama installed!"
                else
                    echo "WARNING: Ollama auto-install failed. Install it manually later."
                fi
            else
                echo "Ollama already installed."
            fi

            if command -v ollama >/dev/null 2>&1; then
                echo "Starting Ollama service..."
                sudo systemctl start ollama 2>/dev/null || ollama serve >/dev/null 2>&1 &
                sleep 3
                echo "Pulling phi3 model (this may take a few minutes)..."
                ollama pull phi3 || echo "Warning: Could not pull phi3. Run 'ollama pull phi3' manually."
            fi
            ;;
        2)
            echo ""
            read -p "Enter your OpenAI API key: " OPENAI_KEY </dev/tty || OPENAI_KEY=""
            sudo bash -c "cat > \"$CONFIG_FILE\" <<EOF
PROVIDER = \"openai\"
MODEL = \"gpt-4o-mini\"

OLLAMA_URL = \"http://localhost:11434/api/generate\"

OPENAI_API_KEY = \"$OPENAI_KEY\"
CLAUDE_API_KEY = \"\"
EOF"
            echo "OpenAI configured!"
            ;;
        3)
            echo ""
            read -p "Enter your Claude API key: " CLAUDE_KEY </dev/tty || CLAUDE_KEY=""
            sudo bash -c "cat > \"$CONFIG_FILE\" <<EOF
PROVIDER = \"claude\"
MODEL = \"claude-3-haiku-20240307\"

OLLAMA_URL = \"http://localhost:11434/api/generate\"

OPENAI_API_KEY = \"\"
CLAUDE_API_KEY = \"$CLAUDE_KEY\"
EOF"
            echo "Claude configured!"
            ;;
        *)
            echo "Invalid choice. Defaulting to Ollama configuration."
            sudo bash -c "cat > \"$CONFIG_FILE\" <<'EOF'
PROVIDER = \"ollama\"
MODEL = \"phi3\"

OLLAMA_URL = \"http://localhost:11434/api/generate\"

OPENAI_API_KEY = \"\"
CLAUDE_API_KEY = \"\"
EOF"
            ;;
    esac
fi

# Cleanup
cd /
sudo rm -rf "$TEMP_DIR"

echo "========================================="
echo " Install Complete! Run: ai --help"
echo "========================================="
