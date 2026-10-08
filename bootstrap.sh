#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES/install/install-essentials.sh"

tpm_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"
if [[ ! -d "$tpm_dir" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
fi
echo 'Packages installed. Install dotfiles with ./install.sh, then Tmux plugins with Ctrl-a, Shift-I.'
