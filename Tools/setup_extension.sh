#!/bin/bash
EXT_DIR="$HOME/.vscode/extensions/antigravity.close-non-typ-tabs-0.0.1"

echo "Removing old extension versions..."
find "$HOME/.vscode/extensions" -maxdepth 1 -name "close-non-typ-tabs" -delete
find "$HOME/.vscode/extensions" -maxdepth 1 -name "antigravity.close-non-typ-tabs*" -delete

echo "Creating extension directory at $EXT_DIR..."
mkdir -p "$EXT_DIR"

echo "Copying files..."
cp "Tools/vscode-close-tabs-extension/package.json" "$EXT_DIR/"
cp "Tools/vscode-close-tabs-extension/extension.js" "$EXT_DIR/"

echo "Verifying installation..."
ls -la "$EXT_DIR"

# Touch extensions.json to trigger VS Code scan
if [ -f "$HOME/.vscode/extensions/extensions.json" ]; then
    touch "$HOME/.vscode/extensions/extensions.json"
fi

echo "Done! Please run 'Developer: Reload Window' in VS Code."
