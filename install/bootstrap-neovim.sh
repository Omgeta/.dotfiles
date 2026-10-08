#!/usr/bin/env bash
set -euo pipefail

# Keep releases side by side; switch the executable only after validation.
version="0.12.5"
case "$(uname -m)" in
  x86_64) arch=x86_64 ;;
  aarch64|arm64) arch=arm64 ;;
  *) echo 'Neovim binaries support Linux x86_64 and arm64.' >&2; exit 1 ;;
esac

release_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/releases/$version-$arch"
if [[ ! -e "$release_dir" ]]; then
  mkdir -p -- "$(dirname -- "$release_dir")"
  staging_dir="$(mktemp -d "$(dirname -- "$release_dir")/.install-XXXXXX")"
  trap 'rm -rf -- "$staging_dir"' EXIT
  curl -fL --retry 3 \
    "https://github.com/neovim/neovim/releases/download/v$version/nvim-linux-$arch.tar.gz" \
    -o "$staging_dir/archive.tar.gz"
  tar -xzf "$staging_dir/archive.tar.gz" -C "$staging_dir" --strip-components=1
  output="$("$staging_dir/bin/nvim" --version)"
  [[ "$output" == "NVIM v$version"* ]] || { echo 'Unexpected Neovim version.' >&2; exit 1; }
  rm -- "$staging_dir/archive.tar.gz"
  mv -T -- "$staging_dir" "$release_dir"
fi

output="$("$release_dir/bin/nvim" --version)"
[[ "$output" == "NVIM v$version"* ]] || { echo 'Invalid installed Neovim release.' >&2; exit 1; }
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
link_config "$release_dir/bin/nvim" "$HOME/.local/bin/nvim"
printf 'Neovim %s installed in %s\n' "$version" "$release_dir"
