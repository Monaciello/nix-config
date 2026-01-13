{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };
}
