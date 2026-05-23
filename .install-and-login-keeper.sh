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

echo "🔒 Verifying Keeper session status..."

# 1. Capture the exact two-word text output from login-status
STATUS_OUTPUT=$("$KEEPER_BIN" login-status 2>&1)

# 2. Match the exact string "Logged in"
# By checking if it matches precisely, "Not logged in" will trigger the else block.
if [[ "$STATUS_OUTPUT" == *"Logged in"* ]]; then
    echo "✅ Keeper Commander is authenticated and ready."
else
    echo "🔐 Keeper session is locked, expired, or not logged in."
    echo "Current status: $STATUS_OUTPUT"
    echo "Starting interactive login sequence..."
    
    # Trigger the interactive login flow natively
    "$KEEPER_BIN" login
fi
