# Neovim Config

A small, practical Neovim setup focused on coding, search, and sane defaults.

## Features

- Plugin management with `lazy.nvim`
- LSP support (Lua, Python, Rust, optional Java)
- Completion with `blink.cmp`
- Syntax highlighting and indentation via Treesitter
- Fuzzy finding with Telescope
- Autopairs and Tokyo Night theme

## Requirements

- Neovim (0.11+ recommended)
- `git` (for plugin bootstrap)

## Optional Tools

The config is designed to start even if these are missing:

- `rg` for Telescope live grep (`<leader>fg`)
- LSP binaries on `PATH`:
  - `lua-language-server`
  - `pylsp`
  - `rust-analyzer`
  - `jdtls` (only if Java LSP is enabled)
- Treesitter parser toolchain for automatic parser updates:
  - `git`
  - a C compiler (`cc`, `clang`, or `gcc`)

If a tool is missing, related features are disabled with a warning instead of crashing.

## Install

Place this directory at:

```bash
~/.config/nvim
```

Then start Neovim:

```bash
nvim
```

## Useful Keymaps

- `<leader>ff` find files
- `<leader>fg` live grep (requires `rg`)
- `<leader>fb` open buffers
- `<leader>fh` help tags
- `<leader>e` file explorer (`:Ex`)

## Local Overrides

Machine-specific settings can be added to:

```bash
lua/config/local.lua
```

This file is optional and can be excluded from version control.

## Troubleshooting

- `:checkhealth`
- `:Lazy`
- `:Mason`
