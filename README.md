# dotfiles

Personal dotfiles for macOS managed with Stow.

## Install
```bash
curl -fsSL https://raw.githubusercontent.com/droczy/.dotfiles/main/install.sh | bash
```

## Configs

- aerospace - window manager
- alacritty - terminal emulator
- karabiner - keyboard remapping
- nvim - editor configuration
- zsh - shell configuration

## Installer Behavior

- Existing conflicting files are moved to `~/.dotfiles-backups/<timestamp>/`
- Repository files are then linked into `$HOME` via `stow --restow .`
- This keeps local backups while making the repository state authoritative

