{ pkgs ? import <nixpkgs> { } }:

let
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
