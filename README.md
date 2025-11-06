# Portable Neovim Configuration

A comprehensive Neovim configuration that works seamlessly on both Nix and non-Nix systems (Linux, macOS, Windows).

## Features

- **Dual Plugin Management**: Automatically uses Nix for plugin management on NixOS, or lazy.nvim on other systems
- **LSP Support**: Pre-configured for multiple languages (Rust, Go, Python, Lua, C/C++, Nix, and more)
- **AI Integration**: GitHub Copilot and Avante.nvim for AI-assisted coding
- **Modern Completion**: Blink.cmp with snippets and fuzzy matching
- **Fuzzy Finding**: Telescope with fzf integration
- **Git Integration**: Fugitive, Gitsigns, and git-worktree support
- **Debugging**: DAP configuration for multiple languages
- **Navigation**: Harpoon, Oil.nvim, and enhanced file navigation
- **UI**: Catppuccin theme, Snacks.nvim dashboard, and more

## Prerequisites

- **Neovim >= 0.10.0** (nightly recommended)
- **Git**
- For non-Nix systems:
  - A C compiler (for compiling treesitter parsers)
  - ripgrep (for Telescope grep functionality)
  - fd (optional, for better file finding)

## Installation

### Linux/macOS (Non-Nix)

```bash
# Clone and install
bash <(curl -s https://raw.githubusercontent.com/przempore/nvim-config/main/install.sh)

# Or clone and install manually
git clone https://github.com/przempore/nvim-config.git
cd nvim-config
./install.sh
```

### Windows

```powershell
# Clone and install
git clone https://github.com/przempore/nvim-config.git
cd nvim-config
.\install.ps1
```

### NixOS/Nix with Home Manager

#### As a Flake Input

Add to your `flake.nix`:

```nix
{
  inputs = {
    nvim-config.url = "github:przempore/nvim-config";
    # ... other inputs
  };

  outputs = { self, nixpkgs, home-manager, nvim-config, ... }: {
    # In your home-manager configuration:
    homeConfigurations.youruser = home-manager.lib.homeManagerConfiguration {
      # ...
      modules = [
        ({ pkgs, ... }: {
          home.file.".config/nvim" = {
            source = nvim-config.packages.${pkgs.system}.config;
            recursive = true;
          };

          programs.neovim = {
            enable = true;
            # Add plugins and extraPackages as needed
          };
        })
      ];
    };
  };
}
```

#### Direct in NixOS Configuration

```nix
# This example uses builtins.fetchGit which is less recommended
# Prefer using it as a flake input (see above) for better reproducibility

{ config, pkgs, ... }:

let
  nvim-config-flake = builtins.getFlake "github:przempore/nvim-config";
in
{
  home.file.".config/nvim" = {
    source = nvim-config-flake.packages.${pkgs.system}.config;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    # Your plugin configuration here
  };
}
```

## Structure

```
nvim-config/
├── init.lua                    # Entry point (auto-detects Nix vs non-Nix)
├── lua/
│   ├── lazy-bootstrap.lua      # Lazy.nvim bootstrap (non-Nix only)
│   ├── my_config/              # Core configuration modules
│   │   ├── init.lua            # Main config initialization
│   │   ├── set.lua             # Vim settings
│   │   ├── lsp.lua             # LSP configuration
│   │   ├── blink_cmp.lua       # Completion setup
│   │   └── ...                 # Other modules
│   └── plugins/                # Lazy.nvim plugin specs
│       ├── core.lua
│       ├── lsp.lua
│       ├── treesitter.lua
│       ├── telescope.lua
│       └── ...
├── after/
│   └── plugin/                 # Plugin configurations
│       ├── colorscheme.lua
│       ├── treesitter.lua
│       └── keymap/             # Keybindings
├── flake.nix                   # Nix flake configuration
├── install.sh                  # Linux/macOS installer
├── install.ps1                 # Windows installer
└── README.md                   # This file
```

## Key Mappings

The configuration uses space as the leader key. Here are some essential mappings:

### File Navigation
- `<leader>pf` - Find files (Telescope)
- `<leader>ps` - Grep search (Telescope)
- `<leader>pv` - Open netrw/Oil file explorer

### Harpoon (Quick File Switching)
- `<leader>a` - Add file to harpoon
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` - Switch between harpooned files

### LSP
- `K` - Hover documentation (LSP Saga)
- `gd` - Go to definition
- `grr` - Find references (Telescope)
- `[d`, `]d` - Previous/next diagnostic
- `<leader>ca` - Code action
- `<leader>rn` - Rename symbol

### Git
- `<leader>gs` - Git status (Fugitive)
- `<leader>gc` - Git checkout (FZF checkout)

### Debugging (DAP)
- `<F5>` - Continue/Start debugging
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
- `<leader>b` - Toggle breakpoint

## Customization

### Adding New Plugins (Non-Nix)

Create a new file in `lua/plugins/` or add to an existing one:

```lua
return {
  {
    "author/plugin-name",
    config = function()
      require("plugin-name").setup({
        -- your configuration
      })
    end,
  },
}
```

### Adding Plugins (Nix)

Update your NixOS configuration to include the plugin in `programs.neovim.plugins`.

### Modifying Settings

Edit `lua/my_config/set.lua` to change Vim settings.

### LSP Configuration

LSP servers are configured in `lua/my_config/lsp.lua`. Add new language servers there.

## Environment Detection

The configuration automatically detects if plugins are managed by Nix by checking if core plugins (like plenary.nvim) are already in the runtimepath:

- **Nix-managed plugins** (NixOS with home-manager): Plugins are pre-installed, lazy.nvim is not loaded
- **Standalone installation**: Lazy.nvim automatically installs and manages plugins

This detection works correctly even on systems with Nix installed but not using Nix to manage Neovim plugins.

## Troubleshooting

### Plugins Not Loading (Non-Nix)

1. Open Neovim and run `:Lazy sync`
2. Check for errors with `:Lazy log`
3. Ensure you have a working internet connection

### LSP Not Working

1. On non-Nix systems, ensure language servers are installed (Mason can help)
2. Run `:Mason` to install language servers
3. Check `:LspInfo` for connection status

### Treesitter Errors

1. Run `:TSUpdate` to update parsers
2. On Windows, ensure you have a C compiler (install MSVC or MinGW)

### Nix Build Failures

1. Ensure you're using Nixpkgs unstable or >= 25.05
2. Run `nix flake update` to update dependencies
3. Check `nix build .#default --show-trace` for detailed errors

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on both Nix and non-Nix systems if possible
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Configuration inspired by ThePrimeagen and other Neovim community members
- Plugin authors for their amazing work
- NixOS community for Nix integration patterns
