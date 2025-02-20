#!/bin/bash

set -e

# Neovim configuration directory
NVIM_CONFIG_DIR="$HOME/.config/nvim"
INIT_LUA_PATH="$NVIM_CONFIG_DIR/init.lua"

# Get the script's current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_INIT_LUA="$SCRIPT_DIR/init.lua"

# Create necessary directories
mkdir -p "$NVIM_CONFIG_DIR"

# Check if init.lua already exists
if [ -e "$INIT_LUA_PATH" ] || [ -L "$INIT_LUA_PATH" ]; then
    echo "$INIT_LUA_PATH already exists. Do you want to remove it and create a new symlink? [y/N]: "
    read -r CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        rm -f "$INIT_LUA_PATH"
        echo "Existing init.lua has been removed."
    else
        echo "Operation canceled."
        exit 1
    fi
fi

# Create the symbolic link
ln -s "$SOURCE_INIT_LUA" "$INIT_LUA_PATH"

echo "Symlink created: $INIT_LUA_PATH -> $SOURCE_INIT_LUA"

