#!/bin/bash

echo "Linux AI CLI Installer"

pip install -r requirements.txt

chmod +x ai
sudo cp ai /usr/local/bin/

echo "Installation complete"
