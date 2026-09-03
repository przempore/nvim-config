vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.autoread = true

if vim.fn.has("win32") == 1 then
  -- Neovim's Windows file watcher can report EPERM when a watched file is deleted.
  vim.g.loaded_autoread = 1

  local autoread_timer = assert(vim.uv.new_timer())
  autoread_timer:start(1000, 1000, function()
    vim.schedule(function()
      pcall(vim.cmd.checktime)
    end)
  end)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      autoread_timer:stop()
      autoread_timer:close()
    end,
  })
end

if vim.g.nvim_config_nix_managed then
  require("my_config")
else
  require("pack-bootstrap")
  require("my_config")
end
