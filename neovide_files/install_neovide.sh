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
BINARY_LOCATION="$SCRIPT_DIR/neovide"

echo "Installing neovide launcher..."
if [[ -f "$BINARY_LOCATION" ]]; then
    # .profile based PATH changes only work for login shells
    # BIN_DIR="$HOME/.local/bin"
    # mkdir -p "$BIN_DIR"
    # cp "$BINARY_LOCATION" "$BIN_DIR/neovide"
    # chmod +x "$BIN_DIR/neovide"
    #
    # echo "Copied $BINARY_LOCATION to $BIN_DIR/neovide and made it executable."

    # ADDING BINARY PATH TO BASHRC -> available in all bashs terminals
    BASHRC="$HOME/.bashrc"
    EXPORT_LINE="export PATH=\"${SCRIPT_DIR}:\$PATH\""

    # Check if the exact export line is already present
    if grep -Fxq "$EXPORT_LINE" "$BASHRC"; then
        echo "✔ '$BINARY_LOCATION' is already in your PATH (in $BASHRC). No changes made."
        exit 0
    fi

    # Append the export line
    {
        echo ""
        echo "# Added by install_neovide.sh from https://github.com/Matzeall/AstroNvim_CustomConfig on $(date)"
        echo "$EXPORT_LINE"
    } >>"$BASHRC"

    echo "✔ Appended PATH entry to $BASHRC"
    echo "    $EXPORT_LINE"
    echo ""
    echo "Now run this to pick up changes in your current session:"
    echo "  source \"$BASHRC\""
else
    echo "Error: $BINARY_LOCATION not found." >&2
    exit 1
fi

exit 0
