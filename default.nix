# For non-flake Nix users
# Usage: nix-build or import in your configuration

{ pkgs ? import <nixpkgs> { } }:

let
  # Just the config files
  configSrc = pkgs.stdenv.mkDerivation {
    name = "nvim-config";
    src = ./.;
    installPhase = ''
      mkdir -p $out
      cp -r after init.lua lua $out/
    '';
  };
in
{
  # Export the config source for use in home.file
  inherit configSrc;

  # Usage example:
  # let nvimConfig = import /path/to/nvim-config { inherit pkgs; };
  # in {
  #   home.file.".config/nvim" = {
  #     source = nvimConfig.configSrc;
  #     recursive = true;
  #   };
  # }
}
