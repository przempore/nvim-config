vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function plugins_are_nix_managed()
  local ok = pcall(require, "plenary.filetype")
  return ok
end

if plugins_are_nix_managed() then
  require("my_config")
else
  require("lazy-bootstrap")
  require("my_config")
end
