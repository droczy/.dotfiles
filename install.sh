#!/bin/bash
set -euo pipefail

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Cloning dotfiles..."
  git clone https://github.com/droczy/.dotfiles.git ~/.dotfiles
else
  echo "Dotfiles already exist, pulling latest..."
  git -C ~/.dotfiles pull
fi

echo "Installing stow..."
if ! command -v stow >/dev/null 2>&1; then
  brew install stow
fi

echo "Checking existing config conflicts..."
cd ~/.dotfiles

backup_root="$HOME/.dotfiles-backups"
timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="$backup_root/$timestamp"
backup_count=0

simulate_output="$(stow --simulate . 2>&1 || true)"

while IFS= read -r line; do
  target_rel=""

  case "$line" in
    *"existing target is not owned by stow:"*)
      target_rel="${line##*: }"
      ;;
    *"existing target "*)
      target_part="${line#*existing target }"
      target_rel="${target_part%% since*}"
      ;;
  esac

  if [ -z "$target_rel" ]; then
    continue
  fi

  if [[ "$target_rel" = /* ]]; then
    src="$target_rel"
    rel_path="${target_rel#/}"
  else
    src="$HOME/$target_rel"
    rel_path="$target_rel"
  fi

  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    continue
  fi

  if [ -L "$src" ]; then
    link_target="$(readlink "$src")"
    if [[ "$link_target" == *".dotfiles/"* ]]; then
      rm "$src"
      echo "Removed unmanaged dotfiles symlink: $src"
      continue
    fi
  fi

  dest="$backup_dir/$rel_path"
  mkdir -p "$(dirname "$dest")"
  mv "$src" "$dest"
  echo "Backed up: $src -> $dest"
  backup_count=$((backup_count + 1))
done <<< "$simulate_output"

if [ "$backup_count" -gt 0 ]; then
  echo "Saved $backup_count conflict path(s) to: $backup_dir"
else
  echo "No conflicts found."
fi

echo "Setting up dotfiles..."
stow --restow .

echo "Done!"
