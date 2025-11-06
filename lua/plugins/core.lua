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
    config = true,
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
