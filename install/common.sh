#!/usr/bin/env bash

# Move conflicts aside once; leave links already pointing to this checkout alone.
link_config() {
  local source_path="$1" destination="$2" backup
  if [[ ! -e "$source_path" ]]; then
    printf 'Missing config: %s\n' "$source_path" >&2
    return 1
  fi
  mkdir -p -- "$(dirname -- "$destination")"
  if [[ -L "$destination" && "$(readlink -- "$destination")" == "$source_path" ]]; then
    return 0
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    backup="${destination}.backup-$(date +%Y%m%d-%H%M%S)-$$"
    while [[ -e "$backup" || -L "$backup" ]]; do
      backup="${backup}.bak"
    done
    mv -- "$destination" "$backup"
    printf 'Backed up %s to %s\n' "$destination" "$backup"
  fi
  ln -s -- "$source_path" "$destination"
}
