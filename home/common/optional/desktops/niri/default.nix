{ lib, pkgs, ... }:
{
  home.packages = lib.attrValues {
    inherit (pkgs.unstable)
      niri
      ;
  };
  home.file.".config/niri/config.kdl".source = ./config.kdl;
}
