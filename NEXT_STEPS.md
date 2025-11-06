# Next Steps for Nvim Config Migration

## Current Status

✅ **Completed:**
- Extracted Neovim configuration to standalone repository at `/home/przemek/Projects/nvim-config`
- Created dual-mode support (Nix and non-Nix systems)
- Set up lazy.nvim for standalone usage
- Created Nix flake for NixOS/home-manager integration
- Added installation scripts for Linux, macOS, and Windows
- Updated NixOS config to use the new repository (local file reference)
- Initial git commit completed

## To Deploy This Configuration

### 1. Create GitHub Repository

```bash
cd /home/przemek/Projects/nvim-config

# Create a new repository on GitHub (e.g., github.com/YOUR_USERNAME/nvim-config)
# Then add the remote and push:

git remote add origin git@github.com:YOUR_USERNAME/nvim-config.git
git branch -M main
git push -u origin main
```

### 2. Update NixOS Config to Use GitHub

Once pushed to GitHub, update these files in your nixos-config:

**In `flake.nix` (line 37):**
```nix
# Change from:
nvim-config.url = "git+file:///home/przemek/Projects/nvim-config";

# To:
nvim-config.url = "github:YOUR_USERNAME/nvim-config";
```

### 3. Update Flake Lock and Test

```bash
cd /home/przemek/Projects/nixos-config

# Update the flake lock to fetch from GitHub
nix flake lock --update-input nvim-config

# Test the configuration
nix flake check

# Apply the changes
make home-switch
```

### 4. Clean Up Old Config (Optional)

After verifying everything works with the new setup, you can remove the old nvim config directory:

```bash
# ONLY do this after confirming the new config works!
rm -rf /home/przemek/Projects/nixos-config/hosts/common/home/apps/nvim/config
```

## Testing the Standalone Configuration

### On a Non-Nix Linux System

```bash
cd /home/przemek/Projects/nvim-config
./install.sh
```

This will:
1. Backup existing Neovim config
2. Install the new config
3. Bootstrap lazy.nvim
4. Install all plugins automatically

### On Windows

```powershell
cd C:\path\to\nvim-config
.\install.ps1
```

### On NixOS (Already Done)

Your NixOS config is already set up to use the new repository. Just run:
```bash
make home-switch
```

## Updating the Configuration

### For NixOS Users (You)

1. Make changes in `/home/przemek/Projects/nvim-config`
2. Commit and push to GitHub
3. In nixos-config: `nix flake lock --update-input nvim-config`
4. Apply: `make home-switch`

### For Non-Nix Users

1. Pull latest changes: `cd ~/.config/nvim && git pull`
2. Open nvim and run `:Lazy sync` if needed

## Sharing with Others

The configuration is now portable! Share it by directing people to:
- GitHub repository URL
- Installation instructions in README.md
- They can use it on Linux, macOS, Windows, or NixOS

## Key Features

### Nix Detection
The `init.lua` automatically detects if running in a Nix environment:
- **Nix**: Uses Nix-managed plugins (no lazy.nvim)
- **Non-Nix**: Bootstraps lazy.nvim and installs plugins

### File Structure
```
nvim-config/
├── init.lua                    # Smart entry point
├── lua/
│   ├── my_config/              # Your config (shared between Nix and non-Nix)
│   ├── plugins/                # Lazy.nvim specs (non-Nix only)
│   └── lazy-bootstrap.lua      # Lazy.nvim setup
├── after/plugin/               # Plugin configs (shared)
├── flake.nix                   # For Nix users
├── install.sh                  # Linux/Mac installer
└── install.ps1                 # Windows installer
```

## Troubleshooting

### If plugins aren't loading on non-Nix systems:
```bash
nvim
:Lazy sync
```

### If NixOS build fails:
```bash
cd /home/przemek/Projects/nixos-config
nix flake check --show-trace
```

### If config changes aren't reflected:
```bash
# For NixOS
cd /home/przemek/Projects/nvim-config
git add -A && git commit -m "Update config"
git push

cd /home/przemek/Projects/nixos-config
nix flake lock --update-input nvim-config
make home-switch
```

## Benefits of This Setup

✅ **Portable**: Works on any system (Linux, macOS, Windows, NixOS)
✅ **Version Controlled**: Separate repo for nvim config
✅ **Declarative**: Nix manages plugins on NixOS
✅ **Flexible**: Non-Nix systems use lazy.nvim
✅ **Shareable**: Easy to share with others
✅ **Maintainable**: Single source of truth for all systems
