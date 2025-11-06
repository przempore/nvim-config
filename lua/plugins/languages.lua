-- Language-specific plugins
return {
  -- Go
  { "fatih/vim-go", ft = "go" },

  -- Rust
  { "rust-lang/rust.vim", ft = "rust" },

  -- QML
  { "peterhoeg/vim-qml", ft = "qml" },

  -- Clang format
  { "rhysd/vim-clang-format" },

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local obsidian_path = vim.fn.expand("~/Projects/second-brain")
      if vim.fn.isdirectory(obsidian_path) == 1 then
        local daily_notes_path = require("my_config.date_formatter_for_obsidian").get_formatted_path()
        local daily_notes_day = require("my_config.date_formatter_for_obsidian").get_filename()

        require("obsidian").setup({
          workspaces = {
            {
              name = "second-brain",
              path = "~/Projects/second-brain",
            },
          },
          follow_url_func = function(url)
            vim.ui.open(url)
          end,
          templates = {
            folder = "~/Projects/second-brain/extras/templates/daily_note_template",
          },
          daily_notes = {
            folder = string.format("Timestamps/%s", daily_notes_path),
            date_format = string.format("%s", daily_notes_day),
            template = nil,
          },
        })
      end
    end,
  },

  -- Image clipboard
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
      },
    },
  },
}
