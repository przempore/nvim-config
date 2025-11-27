-- UI and visual plugins
return {
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
  },

  -- Colorful menu
  { "xzbdmw/colorful-menu.nvim" },
  { "nvzone/menu", dependencies = { "nvzone/volt" } },
  { "nvzone/volt" },

  -- Zen mode
  {
    "folke/zen-mode.nvim",
    config = true,
  },

  -- Number toggle
  { "sitiom/nvim-numbertoggle" },

  -- Firenvim (neovim in browser)
  {
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
}
