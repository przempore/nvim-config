local function is_nix_managed()
  return vim.env.NIX_PROFILES ~= nil
end

if is_nix_managed() then
  require("my_config")
else
  require("lazy-bootstrap")
  require("my_config")
end
