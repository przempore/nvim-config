vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    pcall(vim.treesitter.start, args.buf)
  end,
})
