#!/usr/bin/env bash

echo "========================================="
echo " Uninstalling Linux AI CLI"
echo "========================================="

echo ""
echo "[1/2] Removing Linux AI CLI..."

sudo rm -f /usr/local/bin/ai
sudo rm -rf /usr/lib/linux-ai-cli
sudo rm -rf /etc/linux-ai-cli

# If installed via .deb, remove that too
if command -v dpkg >/dev/null 2>&1; then
    sudo dpkg --remove linux-ai-cli 2>/dev/null || true
fi

echo "      Done."

# -----------------------------------------------
# Optional: Remove Ollama + Models
# -----------------------------------------------
echo ""
if command -v ollama >/dev/null 2>&1; then
    echo "[2/2] Ollama detected on this system."
    echo ""
    echo "  Ollama and its AI models can take up 2-10 GB of disk space."
    echo "  Do you want to remove Ollama and all downloaded models too?"
    echo ""
    
    read -p "  Remove Ollama? (y/n, default: n): " REMOVE_OLLAMA </dev/tty 2>/dev/null || REMOVE_OLLAMA="n"
    REMOVE_OLLAMA=${REMOVE_OLLAMA:-n}

    if [[ "$REMOVE_OLLAMA" == "y" || "$REMOVE_OLLAMA" == "Y" ]]; then
        echo ""
        echo "  Stopping Ollama service..."
        sudo systemctl stop ollama 2>/dev/null || true
        sudo systemctl disable ollama 2>/dev/null || true

        echo "  Removing Ollama binary..."
        sudo rm -f /usr/local/bin/ollama

        echo "  Removing all downloaded models..."
        sudo rm -rf /usr/share/ollama
        rm -rf ~/.ollama

        echo "  Removing systemd service..."
        sudo rm -f /etc/systemd/system/ollama.service
        sudo systemctl daemon-reload 2>/dev/null || true

        # Remove ollama user if exists
        sudo userdel ollama 2>/dev/null || true
        sudo groupdel ollama 2>/dev/null || true

        echo "  Ollama fully removed!"
    else
        echo "  Keeping Ollama installed."
    fi
else
    echo "[2/2] Ollama not detected. Skipping."
fi

echo ""
echo "========================================="
echo " Uninstall complete. Everything removed!"
echo "========================================="
