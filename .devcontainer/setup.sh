#!/bin/bash
set -e # Exit on error for critical steps

echo "--- Starting Codespace Setup ---"

# 1. System Dependencies
sudo apt-get update
sudo apt-get install -y openssh-server tmux gawk

# 2. SSH Keys
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

# 4. Install ble.sh and Fix a-Shell Scroll Bug
echo "Installing ble.sh and configuring a-Shell bindings..."

# Cleanup: This removes the broken lines causing the "option not found" errors
sed -i '/bleopt/d' ~/.bashrc

git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git || true
if [ -d "ble.sh" ]; then
    make -C ble.sh install PREFIX=~/.local
    
    # Add the source command if not present
    if ! grep -q "source ~/.local/share/blesh/ble.sh" ~/.bashrc; then
        echo '[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
    fi

    # Inject a-Shell specific scroll fix bindings
    if ! grep -q "ble-bind -f 'ESC \[ A'" ~/.bashrc; then
        cat << 'EOF' >> ~/.bashrc

# a-Shell Scroll Fix: Bind escape sequences to history navigation
if [[ ${BLE_VERSION-} ]]; then
    ble-bind -f 'ESC [ A' 'history-prev'
    ble-bind -f 'ESC [ B' 'history-next'
    ble-bind -f 'ESC O A' 'history-prev'
    ble-bind -f 'ESC O B' 'history-next'
fi
EOF
    fi
    # Cleanup temporary installation directory
    rm -rf ble.sh
fi

# 5. Gemini CLI
echo "Installing Gemini CLI..."
sudo npm install -g @google/gemini-cli

# 6. Python Requirements & Virtual Environment
echo "Setting up Python environment..."
VENV_PATH="${containerWorkspaceFolder:-/workspaces/Partial-Differential-Equations}/.venv"

if [ -f "gemini_Tutor/requirements.txt" ]; then
    if [ ! -d "$VENV_PATH" ]; then
        python3 -m venv "$VENV_PATH"
    fi
    
    source "$VENV_PATH/bin/activate"
    pip install --upgrade pip
    pip install -r gemini_Tutor/requirements.txt
    echo "Installing Google Drive API libraries..."
    pip install google-api-python-client google-auth-httplib2 google-auth-oauthlib

    
    echo "--- Configuring .bashrc ---"
    
    if ! grep -q "source $VENV_PATH/bin/activate" ~/.bashrc; then
        echo "source $VENV_PATH/bin/activate" >> ~/.bashrc
    fi
    
    if ! grep -q "export PYTHONPATH=\$PYTHONPATH:." ~/.bashrc; then
        echo "export PYTHONPATH=\$PYTHONPATH:." >> ~/.bashrc
    fi
    
    echo "Python dependencies installed."
else
    echo "Warning: gemini_Tutor/requirements.txt not found."
fi

echo "--- Setup Complete ---"
