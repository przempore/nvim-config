#!/usr/bin/env bash
# Installation script for Linux/Mac systems

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Neovim Configuration Installer${NC}"
echo -e "${GREEN}================================${NC}\n"

if ! command -v nvim &> /dev/null; then
    echo -e "${RED}Error: Neovim is not installed!${NC}"
    echo "Please install Neovim first:"
    echo "  - macOS: brew install neovim"
    echo "  - Linux: Check your distribution's package manager"
    echo "  - Or visit: https://github.com/neovim/neovim/releases"
    exit 1
fi

echo -e "${GREEN}✓${NC} Neovim found: $(nvim --version | head -n1)"

if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed!${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Git found"

if [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG_DIR="$HOME/.config/nvim"
else
    CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
fi

if [ -d "$CONFIG_DIR" ]; then
    BACKUP_DIR="${CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Warning: Existing Neovim config found${NC}"
    echo -e "Backing up to: ${BACKUP_DIR}"
    mv "$CONFIG_DIR" "$BACKUP_DIR"
fi

if [ -n "$1" ]; then
    echo -e "\n${GREEN}Installing from: $1${NC}"
    if [[ "$1" == http* ]] || [[ "$1" == git@* ]]; then
        git clone "$1" "$CONFIG_DIR"
    else
        cp -r "$1" "$CONFIG_DIR"
    fi
else
    if [ -f "$(dirname "$0")/init.lua" ]; then
        echo -e "\n${GREEN}Installing from current directory${NC}"
        mkdir -p "$CONFIG_DIR"
        cp -r "$(dirname "$0")"/* "$CONFIG_DIR/"
    else
        echo -e "${RED}Error: Please provide repository URL or run from config directory${NC}"
        echo "Usage: ./install.sh [repository-url or path]"
        exit 1
    fi
fi

echo -e "\n${GREEN}✓${NC} Configuration installed to: $CONFIG_DIR"

echo -e "\n${GREEN}Starting Neovim to install plugins...${NC}"
echo "  Lazy.nvim will automatically install all plugins"
echo "  This may take a few minutes on first run..."
echo ""
sleep 2

# Launch nvim to trigger lazy.nvim bootstrap
nvim --headless "+Lazy! sync" +qa

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✓${NC} Plugins installed successfully!"
else
    echo -e "\n${YELLOW}Warning: Plugin installation may have encountered issues${NC}"
    echo "Run 'nvim' and execute ':Lazy sync' to retry"
fi

echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "Run ${YELLOW}nvim${NC} to start using your new configuration"
echo ""
echo "For more information, see the README.md"
