if not vim.pack or type(vim.pack.add) ~= "function" then
  vim.notify("vim.pack requires Neovim 0.12 or newer", vim.log.levels.ERROR)
  return
end

local function on_pack_changed(callback)
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = callback,
  })
end

on_pack_changed(function(ev)
  local name = ev.data.spec.name
  if name ~= "firenvim" or ev.data.kind ~= "install" then
    return
  end

  if not ev.data.active then
    vim.cmd.packadd("firenvim")
  end
  vim.fn["firenvim#install"](0)
end)

on_pack_changed(function(ev)
  local name = ev.data.spec.name
  if name ~= "markdown-preview.nvim" or ev.data.kind ~= "install" then
    return
  end

  if not ev.data.active then
    vim.cmd.packadd("markdown-preview.nvim")
  end
  vim.fn["mkdp#util#install"]()
end)

local plugins = {
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/rcarriga/nvim-notify",
  "https://github.com/stevearc/dressing.nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-rhubarb",
  "https://github.com/stsewd/fzf-checkout.vim",
  "https://github.com/junegunn/fzf",
  "https://github.com/junegunn/fzf.vim",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/tpope/vim-sleuth",
  "https://github.com/mbbill/undotree",
  "https://github.com/ThePrimeagen/vim-be-good",
  "https://github.com/andrewferrier/debugprint.nvim",
  "https://github.com/cajames/copy-reference.nvim",
  "https://github.com/epwalsh/pomo.nvim",
  "https://github.com/catppuccin/nvim",
  "https://github.com/xzbdmw/colorful-menu.nvim",
  "https://github.com/nvzone/menu",
  "https://github.com/nvzone/volt",
  "https://github.com/folke/zen-mode.nvim",
  "https://github.com/sitiom/nvim-numbertoggle",
  { src = "https://github.com/glacambre/firenvim", name = "firenvim" },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/neodev.nvim",
  "https://github.com/nvimtools/none-ls.nvim",
  { src = "https://github.com/VonHeikemen/lsp-zero.nvim", version = "v3.x" },
  "https://github.com/nvim-lua/lsp_extensions.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/nvimdev/lspsaga.nvim",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/Saghen/blink.compat",
  "https://github.com/giuxtaposition/blink-cmp-copilot",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/onsails/lspkind.nvim",
  "https://github.com/zbirenbaum/copilot.lua",
  { src = "https://github.com/olimorris/codecompanion.nvim", version = vim.version.range("^19.0.0") },
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/HakonHarnes/img-clip.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "master" },
  "https://github.com/ThePrimeagen/harpoon",
  "https://github.com/awerebea/git-worktree.nvim",
  "https://github.com/vijaymarupudi/nvim-fzf",
  "https://github.com/Cassin01/wf.nvim",
  "https://github.com/dhananjaylatkar/cscope_maps.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/fatih/vim-go",
  "https://github.com/rust-lang/rust.vim",
  "https://github.com/peterhoeg/vim-qml",
  "https://github.com/rhysd/vim-clang-format",
  { src = "https://github.com/iamcco/markdown-preview.nvim", name = "markdown-preview.nvim" },
  "https://github.com/epwalsh/obsidian.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/nvim-neotest/nvim-nio",
}

local function plugin_name(spec)
  if type(spec) == "table" and spec.name then
    return spec.name
  end

  local src = type(spec) == "table" and spec.src or spec
  return src:match("([^/]+)%.git$") or src:match("([^/]+)$")
end

local function plugin_path(name)
  return vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. name
end

local function start_plugin_path(name)
  return vim.fn.stdpath("data") .. "/site/pack/core/start/" .. name
end

local missing = {}
for _, spec in ipairs(plugins) do
  local name = plugin_name(spec)
  if not name then
    table.insert(missing, spec)
  elseif vim.fn.isdirectory(start_plugin_path(name)) == 1 then
    -- Start packages are loaded by Neovim's package loader before this file runs.
  elseif vim.fn.isdirectory(plugin_path(name)) == 1 then
    vim.fn.mkdir(vim.fn.stdpath("data") .. "/site/pack/core/start", "p")
    vim.fn.rename(plugin_path(name), start_plugin_path(name))
  else
    table.insert(missing, spec)
  end
end

if #missing > 0 then
  vim.pack.add(missing)
end
