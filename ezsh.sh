#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <script-file>"
    exit 1
fi

SCRIPT_FILE="$1"

if [ ! -f "$SCRIPT_FILE" ]; then
    echo "File $SCRIPT_FILE does not exist."
    exit 1
fi

chmod +x "$SCRIPT_FILE"

SHELL_NAME=$(basename "$SHELL")

if [ "$SHELL_NAME" = "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [ "$SHELL_NAME" = "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    echo "Unsupported shell: $SHELL_NAME"
    exit 1
fi

SCRIPT_NAME=$(basename "$SCRIPT_FILE" .sh)
ALIAS_ENTRY="alias $SCRIPT_NAME=\"$SCRIPT_FILE\""
MARKER="# AAATBSGSHU"

if grep -q "$MARKER" "$CONFIG_FILE"; then
    sed -i "/$MARKER/a\\$ALIAS_ENTRY" "$CONFIG_FILE"
else
    echo "$MARKER" >> "$CONFIG_FILE"
    echo "$ALIAS_ENTRY" >> "$CONFIG_FILE"
fi

echo "Alias added for $SCRIPT_FILE in $CONFIG_FILE"
