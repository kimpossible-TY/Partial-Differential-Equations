#!/bin/bash
set -e # Exit on error for critical steps, but we will wrap non-critical ones

echo "--- Starting Codespace Setup ---"

# 1. System Dependencies
sudo apt-get update
sudo apt-get install -y openssh-server tmux gawk

# 2. SSH Keys (Non-critical)
echo "Setting up SSH keys..."
mkdir -p ~/.ssh
curl -s https://github.com/kimpossible-TY.keys >> ~/.ssh/authorized_keys || echo "Failed to fetch SSH keys"
chmod 600 ~/.ssh/authorized_keys

# 3. Install Typst
echo "Installing Typst..."
if curl -L -o typst.tar.xz https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz; then
    tar -xvf typst.tar.xz
    sudo mv typst-x86_64-unknown-linux-musl/typst /usr/local/bin/
    rm -rf typst.tar.xz typst-x86_64-unknown-linux-musl
else
    echo "Warning: Typst installation failed."
fi

# 4. Install ble.sh (Shell improvement)
echo "Installing ble.sh..."
git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git || true
if [ -d "ble.sh" ]; then
    make -C ble.sh install PREFIX=~/.local
    echo '[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
    rm -rf ble.sh
fi

# 5. Gemini CLI (Critical)
echo "Installing Gemini CLI..."
sudo npm install -g @google/gemini-cli

echo "--- Setup Complete ---"
