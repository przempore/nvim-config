vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.autoread = true

local function plugins_are_nix_managed()
  local ok = pcall(require, "plenary.filetype")
  return ok
end

if plugins_are_nix_managed() then
  require("my_config")
else
  require("pack-bootstrap")
  require("my_config")
end
