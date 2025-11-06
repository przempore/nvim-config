-- Telescope and navigation plugins
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Git worktree
  {
    "awerebea/git-worktree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  },

  -- FZF
  { "junegunn/fzf", build = "./install --bin" },
  { "junegunn/fzf.vim" },
  { "vijaymarupudi/nvim-fzf" },

  -- Which-key helper
  {
    "Cassin01/wf.nvim",
    config = function()
      require("wf").setup({
        theme = "chad",
      })
    end,
  },

  -- Cscope integration
  {
    "dhananjaylatkar/cscope_maps.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
    },
  },
}
