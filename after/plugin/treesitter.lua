local parser_by_filetype = {
  bash = "bash",
  c = "c",
  cpp = "cpp",
  css = "css",
  diff = "diff",
  go = "go",
  html = "html",
  javascript = "javascript",
  json = "json",
  lua = "lua",
  markdown = "markdown",
  ps1 = "powershell",
  python = "python",
  rust = "rust",
  sh = "bash",
  sql = "sql",
  toml = "toml",
  typescript = "typescript",
  typescriptreact = "tsx",
  vim = "vim",
  xml = "xml",
  yaml = "yaml",
  zsh = "bash",
}

vim.treesitter.language.register("xml", { "svg", "xslt" })
vim.treesitter.language.register("powershell", { "psm1" })

local max_filesize = 512 * 1024

local keep_legacy_syntax = {
  markdown = true,
  vimdoc = true,
}

local function has_highlights_query(lang)
  local query_path = string.format("queries/%s/highlights.scm", lang)
  return #vim.api.nvim_get_runtime_file(query_path, true) > 0
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(parser_by_filetype),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    local file = vim.api.nvim_buf_get_name(args.buf)
    if file ~= "" then
      local ok, stat = pcall(vim.uv.fs_stat, file)
      if ok and stat and stat.size and stat.size > max_filesize then
        return
      end
    end

    local filetype = vim.bo[args.buf].filetype
    local lang = parser_by_filetype[filetype]
    if not lang then
      return
    end

    local parser_ok = vim.treesitter.language.add(lang)
    if not parser_ok then
      return
    end

    local ts_started = pcall(vim.treesitter.start, args.buf, lang)

    if keep_legacy_syntax[filetype] or not ts_started or not has_highlights_query(lang) then
      vim.bo[args.buf].syntax = "ON"
    end
  end,
})
