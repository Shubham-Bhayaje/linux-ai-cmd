#!/usr/bin/env bash

echo "========================================="
echo " Uninstalling Linux AI CLI"
echo "========================================="

echo ""
echo "Removing files..."

sudo rm -f /usr/local/bin/ai
sudo rm -rf /usr/lib/linux-ai-cli
sudo rm -rf /etc/linux-ai-cli

# If installed via .deb, remove that too
if command -v dpkg >/dev/null 2>&1; then
    sudo dpkg --remove linux-ai-cli 2>/dev/null || true
fi

echo ""
echo "========================================="
echo " Linux AI CLI has been uninstalled."
echo "========================================="
