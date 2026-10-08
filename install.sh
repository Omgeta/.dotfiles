#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
VIMCONFIG="${VIMCONFIG:-$XDG_CONFIG_HOME/nvim}"

case "$*" in
  -y|--yes) ;;
  -h|--help) echo "Usage: $0 [-y|--yes]"; exit 0 ;;
  "")
    read -r -p 'Install dotfiles and back up existing configs? [y/N] ' answer || exit 0
    [[ "$answer" == [yY] || "$answer" == [yY][eE][sS] ]] || exit 0
    ;;
  *) echo "Usage: $0 [-y|--yes]" >&2; exit 2 ;;
esac

source "$DOTFILES/install/common.sh"
for component in zsh git tmux nvim; do
  echo "Installing $component config"
  source "$DOTFILES/install/install-$component.sh"
done
echo 'Dotfiles installed. Start a new shell to load them.'
