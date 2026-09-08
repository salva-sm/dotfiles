#!/bin/bash

# --- Path configuration ---
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
HOME_DIR=$HOME

if command -v cygpath >/dev/null 2>&1; then
    APPDATA_DIR="$(cygpath "$APPDATA")"
else
    APPDATA_DIR="/c/Users/$USER/AppData/Roaming"
fi
VSCODE_USER_DIR="$APPDATA_DIR/Code/User"
ZED_USER_DIR="$APPDATA_DIR/Zed"

echo "🔄 Reverting Dotfiles changes..."

# --- 1. Revert Git Bash ---
echo "🗑️  Removing .bashrc loader..."
rm -f "$HOME_DIR/.bashrc"

if [ -f "$HOME_DIR/.bashrc.bak" ]; then
    echo "📦 Restoring .bashrc.bak..."
    mv "$HOME_DIR/.bashrc.bak" "$HOME_DIR/.bashrc"
fi

# --- 2. Revert editor config (both editors: the choice may have changed) ---
unlink_editor() {
    local target="$1"
    if [ -L "$target" ]; then
        echo "🗑️  Removing link: $(basename "$target")"
        rm -f "$target"
    fi
    # Restore a backup made at install time, if any.
    if [ -e "$target.bak" ]; then
        echo "📦 Restoring $(basename "$target").bak"
        mv "$target.bak" "$target"
    fi
}

unlink_editor "$VSCODE_USER_DIR/settings.json"
unlink_editor "$VSCODE_USER_DIR/snippets"
unlink_editor "$ZED_USER_DIR/settings.json"
unlink_editor "$ZED_USER_DIR/keymap.json"

# --- 3. Remove generated workspace (keeps your env.local) ---
WS_OUTPUT="$DOTFILES_DIR/vscode/workspaces/sfcc.code-workspace"
if [ -f "$WS_OUTPUT" ]; then
    echo "🗑️  Removing generated workspace..."
    rm -f "$WS_OUTPUT"
fi

echo "✅ Uninstallation complete! Your environment is back to normal."
