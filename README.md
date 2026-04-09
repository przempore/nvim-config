# Neovim Configuration

Portable Neovim config for Nix and non-Nix systems.

## Plugin Management

- **Nix-managed setup**: plugins come from Nix (`flake.nix`).
- **Non-Nix setup**: plugins are managed with built-in `vim.pack` via `lua/pack-bootstrap.lua`.

This repository no longer uses `lazy.nvim`.

## Requirements

- **Neovim >= 0.12** (required for `vim.pack`)
- `git`
- `ripgrep` (recommended for Telescope)
- Optional build tools for native plugin components

## Structure

```text
nvim-config/
├── init.lua
├── lua/
│   ├── pack-bootstrap.lua
│   └── my_config/
├── after/plugin/
├── flake.nix
├── install.sh
└── install.ps1
```

## Install

### Linux/macOS

```bash
git clone https://github.com/przempore/nvim-config.git
cd nvim-config
./install.sh
```

### Windows

```powershell
git clone https://github.com/przempore/nvim-config.git
cd nvim-config
.\install.ps1
```

On first interactive launch (`nvim`), `vim.pack` installs missing plugins.

## Notes

- Tree-sitter highlighting uses Neovim built-in Tree-sitter startup in `after/plugin/treesitter.lua`.
- Harpoon mappings use Harpoon v1 API in `after/plugin/keymap/harpoon.lua`.
- If you use Nix/Home Manager, consume `packages.<system>.config` from this flake.
