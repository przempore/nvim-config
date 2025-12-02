{
  description = "Portable Neovim configuration for Nix and non-Nix systems";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { system, ... }:
        let
          pkgs-with-overlay = import inputs.nixpkgs {
            inherit system;
            overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
            config.allowUnfree = true;
          };

          inherit (pkgs-with-overlay) vimPlugins vimUtils fetchFromGitHub wrapNeovim stdenv;

          cscope_maps-nvim = vimUtils.buildVimPlugin {
            name = "cscope_maps-nvim";
            nativeBuildInputs = with pkgs-with-overlay; [ pkg-config readline ];
            src = fetchFromGitHub {
              owner = "dhananjaylatkar";
              repo = "cscope_maps.nvim";
              rev = "66d044b1949aa4912261bbc61da845369d54f971";
              sha256 = "sha256-pC5iWtuHz2Gr9EgEJXaux9VEM4IJhVmQ4bkGC0GEvuA=";
            };
            dependencies = [ vimPlugins.telescope-nvim vimPlugins.fzf-lua ];
            nvimSkipModules = [ "cscope.pickers.telescope" "cscope.pickers.fzf-lua" ];
          };

          wf-nvim = vimUtils.buildVimPlugin {
            name = "wf-nvim";
            nativeBuildInputs = with pkgs-with-overlay; [ pkg-config readline ];
            src = fetchFromGitHub {
              owner = "Cassin01";
              repo = "wf.nvim";
              rev = "716f2151bef7b38426a99802e89566ac9211978a";
              sha256 = "sha256-4RwTZP3Oz0Rj/PB9NV+FsdOsLMZZQMW+y25A7MWt9qo=";
            };
          };

          telescope-git-worktrees = vimUtils.buildVimPlugin {
            name = "telescope-git-worktrees";
            src = fetchFromGitHub {
              owner = "awerebea";
              repo = "git-worktree.nvim";
              rev = "a3917d0b7ca32e7faeed410cd6b0c572bf6384ac";
              sha256 = "sha256-CC9+h1i+l9TbE60LABZnwjkHy94VGQ7Hqd5jVHEW+mw=";
            };
            dependencies = [ vimPlugins.plenary-nvim vimPlugins.telescope-nvim ];
            nvimRequireCheck = [ "git-worktree.status" "git-worktree.enum" ];
            nvimSkipModules = [ "git-worktree.test" "git-worktree" ];
          };

          neovim-pkg = inputs.neovim-nightly-overlay.packages.${system}.neovim.overrideAttrs (old: {
            meta = old.meta or { } // {
              maintainers = [ ];
            };
          });

          configFiles = stdenv.mkDerivation {
            name = "nvim-config";
            src = self;
            installPhase = ''
              mkdir -p $out
              cp -r after init.lua lua $out/
            '';
          };

          pluginsList = [
            cscope_maps-nvim
            telescope-git-worktrees
            wf-nvim
          ] ++ (with vimPlugins; [
            CopilotChat-nvim
            avante-nvim
            blink-cmp
            blink-cmp-avante
            blink-cmp-dictionary
            blink-cmp-copilot
            colorful-menu-nvim
            comment-nvim
            copilot-lua
            debugprint-nvim
            dressing-nvim
            fidget-nvim
            firenvim
            friendly-snippets
            fzf-checkout-vim
            fzf-vim
            gitsigns-nvim
            harpoon2
            img-clip-nvim
            lsp-zero-nvim
            lsp_extensions-nvim
            lspkind-nvim
            lspsaga-nvim
            luasnip
            markdown-preview-nvim
            mason-nvim
            mason-tool-installer-nvim
            neodev-nvim
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
            nvim-fzf
            nvim-lint
            nvim-notify
            nvim-numbertoggle
            nvim-treesitter-context
            nvim-treesitter-textobjects
            nvim-treesitter.withAllGrammars
            nvim-web-devicons
            obsidian-nvim
            oil-nvim
            palette-nvim
            playground
            plenary-nvim
            pomo-nvim
            rust-vim
            snacks-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            undotree
            vim-be-good
            vim-clang-format
            vim-fugitive
            vim-go
            vim-qml
            vim-rhubarb
            vim-sleuth
            zen-mode-nvim
          ]);
        in
        {
          packages = {
            default = wrapNeovim neovim-pkg {
              configure = {
                customRC = ''
                  lua dofile("${configFiles}/init.lua")
                '';
                packages.all = {
                  start = pluginsList;
                };
              };
            };

            config = configFiles;

            neovim-unwrapped = neovim-pkg;
          };

          # Using legacyPackages as a workaround since flake-parts doesn't have
          # a standard way to export custom per-system attributes
          legacyPackages = {
            inherit pluginsList;
          };
        };

      flake = {
        homeManagerModules.default = { config, lib, pkgs, ... }: {
          options.programs.nvim-config = {
            enable = lib.mkEnableOption "nvim-config";
          };

          config = lib.mkIf config.programs.nvim-config.enable {
            home.file.".config/nvim" = {
              source = self.packages.${pkgs.system}.config;
              recursive = true;
            };
          };
        };
      };
    };
}
