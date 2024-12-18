#!/usr/bin/env bash

mkdir -p "$ZDOTDIR"

sudo apt install zsh

ln -sf "$DOTFILES/zsh/zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES/zsh/zshprofile" "$HOME/.zshprofile"
ln -sf "$DOTFILES/zsh/zshrc" "$ZDOTDIR/.zshrc"

chsh -s $(which zsh)

