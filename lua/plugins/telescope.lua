-- Telescope and navigation plugins
local has_make = vim.fn.executable("make") == 1
local has_cmake = vim.fn.executable("cmake") == 1

local fzf_native_build = nil
if has_make then
  fzf_native_build = "make"
elseif has_cmake then
  fzf_native_build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
end

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = fzf_native_build,
        cond = has_make or has_cmake,
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
      -- Load fzf extension if it's available (build might fail on some systems)
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

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
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
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
