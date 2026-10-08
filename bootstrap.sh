#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
case "$*" in
  ""|-y|--yes) ;;
  -h|--help) echo "Usage: $0 [-y|--yes] (install packages, Neovim, and configs)"; exit 0 ;;
  *) echo "Usage: $0 [-y|--yes]" >&2; exit 2 ;;
esac

source "$DOTFILES/install/install-essentials.sh"
bash "$DOTFILES/install/bootstrap-neovim.sh"
git -C "$DOTFILES" submodule update --init --recursive

tpm_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"
if [[ ! -d "$tpm_dir" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
fi
bash "$DOTFILES/install.sh" -y
echo 'Setup complete. Start a new shell, then run :Lazy sync and :checkhealth in Neovim.'
echo 'Install Tmux plugins with Ctrl-a, Shift-I.'
