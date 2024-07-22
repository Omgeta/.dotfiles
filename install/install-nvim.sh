#!/usr/bin/env bash

# Install vimconfig folder
if [ ! -d "$VIMCONFIG" ]; then
	mkdir "$VIMCONFIG"
fi

# Delete packer_compile folder
rm -rf "$VIMCONFIG/plugin"

# Install nvim config files
ln -sf "$DOTFILES/nvim/init.lua" "$VIMCONFIG"

# Create vim sessions and macros folder
mkdir -p "$VIMCONFIG/sessions"

# Create all mandatory folders if they don't exist already
mkdir -p "$VIMCONFIG/plugged"
mkdir -p "$VIMCONFIG/backup"
mkdir -p "$VIMCONFIG/undo"
mkdir -p "$VIMCONFIG/swap"
mkdir -p "$VIMCONFIG/after"

# lua
rm -rf "$VIMCONFIG/lua"
ln -sf "$DOTFILES/nvim/lua" "$VIMCONFIG"

# snippets
rm -rf "$VIMCONFIG/UltiSnips"
ln -sf "$DOTFILES/nvim/UltiSnips" "$VIMCONFIG"

# pip install neovim --quiet
# npm -g install neovim --quiet
