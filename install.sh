#!/bin/bash
set -e

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Cloning dotfiles..."
  git clone git@github.com:droczy/.dotfiles.git ~/.dotfiles
else
  echo "Dotfiles already exist, pulling latest..."
  git -C ~/.dotfiles pull
fi

echo "Installing stow..."
brew install stow

echo "Removing existing configs..."
cd ~/.dotfiles
# Für jede Datei im Repo: lösche die auf dem System falls sie existiert
stow --simulate . 2>&1 | grep "existing target" | awk '{print $NF}' | while read f; do
  rm -rf "$HOME/$f"
done

echo "Setting up dotfiles..."
stow .

echo "Done!"
