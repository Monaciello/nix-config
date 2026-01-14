{ lib, pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };
  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      xwayland-satellite # xwayland support

      #TODO(niri): decide
      #swaylock
      ;
  };

  # extras recommended by niri
  services.gnome.gnome-keyring.enable = true;
  #TODO(niri): decide
  #security.services.pam.swaylock ={};
}
