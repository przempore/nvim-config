vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.autoread = true

if vim.g.nvim_config_nix_managed then
  require("my_config")
else
  require("pack-bootstrap")
  require("my_config")
end
