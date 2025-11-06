-- Core plugins
return {
  -- Essential dependencies
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- UI enhancements
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
      vim.notify = require("notify")
    end,
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("my_config.dressing")
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("my_config.snacks")
    end,
  },

  -- File navigation
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        default_file_explorer = false,
        columns = { "icon", "permissions", "size", "mtime" },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        view_options = { show_hidden = true },
        float = {
          padding = 2,
          border = "rounded",
        },
      })
      -- Set up keymap
      vim.keymap.set("n", "<leader>ov", ":Oil --float<CR>",
        { noremap = true, silent = true, desc = "Open Oil file explorer" })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "tpope/vim-rhubarb",
  },
  {
    "stsewd/fzf-checkout.vim",
    dependencies = { "junegunn/fzf", "junegunn/fzf.vim" },
  },

  -- Utilities
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  { "tpope/vim-sleuth" },
  { "mbbill/undotree" },
  { "ThePrimeagen/vim-be-good" },
  {
    "andrewferrier/debugprint.nvim",
    config = function()
      require("my_config.debugprint")
    end,
  },
  {
    "epwalsh/pomo.nvim",
    version = "*",
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat" },
    config = function()
      require("pomo").setup({
        update_interval = 1000,
        notifiers = {
          {
            name = "Default",
            opts = {
              sticky = true,
              title_icon = "󱎫",
              text_icon = "󰄉",
            },
          },
          { name = "System" },
        },
        timers = {
          Break = {
            { name = "System" },
          },
        },
      })
    end,
  },
}
