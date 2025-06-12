#!/usr/bin/env bash
set -euo pipefail

# Determine the directory where this script resides
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Install font
FONT_SRC="$SCRIPT_DIR/IosevkaTermSlabNerdFontMono-Regular.ttf"
FONT_DST="$HOME/.local/share/fonts/"

echo "Installing font..."
mkdir -p "$FONT_DST"
if [[ -f "$FONT_SRC" ]]; then
    cp "$FONT_SRC" "$FONT_DST"
    echo "Copied $FONT_SRC to $FONT_DST"
    fc-cache -f -v
    echo "Font cache updated."
else
    echo "Error: $FONT_SRC not found." >&2
    exit 1
fi

# 2. Install neovide launcher script
BIN_DIR="$HOME/.local/bin"
LAUNCHER_SRC="$SCRIPT_DIR/neovide"

echo "Installing neovide launcher..."
mkdir -p "$BIN_DIR"
if [[ -f "$LAUNCHER_SRC" ]]; then
    cp "$LAUNCHER_SRC" "$BIN_DIR/neovide"
    chmod +x "$BIN_DIR/neovide"

    if [[ -f "$HOME/.profile" ]]; then # resource to make neovide immediatly available
        source "$HOME/.profile"
    fi
    echo "Copied $LAUNCHER_SRC to $BIN_DIR/neovide and made it executable."
else
    echo "Error: $LAUNCHER_SRC not found." >&2
    exit 1
fi

echo
echo
echo "Ensure that $BIN_DIR is in your PATH. (usually in ~/.profile)"
echo "-> depending on your setup neovide should be available in all future terminals now or in any case after a restart)"
echo "Additionally the neovide command should also be available in current shell now. If it didn't, do: source ~/.profile yourself"

exit 0
