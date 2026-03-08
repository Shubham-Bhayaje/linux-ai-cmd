#!/usr/bin/env bash
set -e

echo "========================================="
echo " Installing Linux AI CLI (One-Line Setup)"
echo "========================================="

echo "[1/4] Installing build requirements..."

if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y >/dev/null
    sudo apt-get install -y git dpkg-dev curl zstd python3 python3-pip >/dev/null
    PKG_MGR="apt"
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y git curl zstd python3 python3-pip >/dev/null
    PKG_MGR="dnf"
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y git curl zstd python3 python3-pip >/dev/null
    PKG_MGR="yum"
else
    echo "Unsupported package manager. Please install git, curl, zstd, and python3 manually."
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
    echo "Note: Automatic Ollama setup is currently only supported via the .deb installer."
    echo "Please edit /etc/linux-ai-cli/config.py to configure your AI provider."
fi

# Cleanup
cd /
sudo rm -rf "$TEMP_DIR"

echo "========================================="
echo " Install Complete! Run: ai --help"
echo "========================================="
