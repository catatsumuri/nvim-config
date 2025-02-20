#!/bin/bash

set -e

# Path to .bash_aliases
BASH_ALIASES="$HOME/.bash_aliases"

# Check if .bash_aliases exists, if not, create it
if [ ! -f "$BASH_ALIASES" ]; then
    touch "$BASH_ALIASES"
    echo "Created $BASH_ALIASES"
fi

# Check if alias already exists
if grep -q "alias vi=" "$BASH_ALIASES"; then
    echo "An alias for 'vi' already exists in $BASH_ALIASES."
    echo "Do you want to replace it with 'alias vi=nvim'? [y/N]: "
    read -r CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        sed -i '/alias vi=/d' "$BASH_ALIASES"
        echo "alias vi='nvim'" >> "$BASH_ALIASES"
        echo "Updated alias: vi -> nvim"
    else
        echo "Operation canceled."
        exit 1
    fi
else
    echo "alias vi='nvim'" >> "$BASH_ALIASES"
    echo "Added alias: vi -> nvim"
fi

echo "Reloading .bash_aliases..."
# Reload aliases in the current session
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile"
fi

echo "Setup complete! You can now use 'vi' as an alias for 'nvim'."
