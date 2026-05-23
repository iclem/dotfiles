#!/bin/bash

# Store the venv in the standard user cache directory
VENV_DIR="$HOME/.cache/chezmoi-keeper-venv"
KEEPER_BIN="$VENV_DIR/bin/keeper"

if [ ! -f "$KEEPER_BIN" ]; then
    echo "📦 Creating isolated Python venv in ~/.cache..."
    python3 -m venv "$VENV_DIR"
    "$VENV_DIR/bin/pip" install --upgrade pip
    "$VENV_DIR/bin/pip" install keepercommander
fi

if ! "$KEEPER_BIN" list --format json &> /dev/null; then
    echo "🔐 Keeper session expired or not authenticated."
    "$KEEPER_BIN" shell
else
    echo "✅ Keeper Commander is authenticated and ready."
fi
