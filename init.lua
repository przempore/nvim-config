-- Detect if running in Nix environment
-- Nix manages plugins via programs.neovim.plugins, so lazy.nvim should not be used
local function is_nix_managed()
  -- Check if we're in a Nix environment by looking for NIX_PROFILES
  return vim.env.NIX_PROFILES ~= nil
end

-- Bootstrap configuration based on environment
if is_nix_managed() then
  -- Nix manages plugins, just load our configuration
  require("my_config")
else
  -- Non-Nix system: use lazy.nvim to manage plugins
  require("lazy-bootstrap")
  require("my_config")
end
