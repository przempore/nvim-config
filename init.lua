-- Detect if plugins are managed by Nix
-- When using programs.neovim.plugins in NixOS/home-manager, plugins are pre-installed in the runtimepath
-- We check if a common plugin (plenary) is already available to determine if lazy.nvim is needed
local function plugins_are_nix_managed()
  -- Try to check if plenary.nvim (a common dependency) is in runtimepath
  -- If it's available, plugins are managed by Nix
  local ok = pcall(require, "plenary.filetype")
  return ok
end

-- Bootstrap configuration based on environment
if plugins_are_nix_managed() then
  -- Plugins are managed by Nix, just load our configuration
  require("my_config")
else
  -- Non-Nix system or standalone: use lazy.nvim to manage plugins
  require("lazy-bootstrap")
  require("my_config")
end
