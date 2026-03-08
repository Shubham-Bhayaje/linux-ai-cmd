#!/bin/bash
set -e

echo "========================================="
echo " Installing Linux AI CLI (One-Line Setup)"
echo "========================================="

# 1. Install prerequisites for building the .deb
echo "[1/4] Installing build requirements..."
sudo apt-get update -y > /dev/null
sudo apt-get install -y git dpkg-dev curl zstd > /dev/null

# 2. Clone the repository to a temporary directory
echo "[2/4] Cloning the repository..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
git clone https://github.com/Shubham-Bhayaje/linux-ai-cmd.git . > /dev/null 2>&1

# 3. Build the .deb package
echo "[3/4] Building the .deb package..."
chmod +x build-deb.sh
./build-deb.sh > /dev/null

# 4. Install the package (triggers the interactive setup wizard)
echo "[4/4] Installing package (will prompt for AI Provider)..."
sudo dpkg -i linux-ai-cli_3.0.0.deb

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo "========================================="
echo " Install Complete! Run: ai --help"
echo "========================================="
