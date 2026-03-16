#!/bin/bash
set -e

echo "Installing stow..."
brew install stow

echo "Setting up dotfiles..."
cd ~/.dotfiles
stow --adopt .

echo "Done!"
