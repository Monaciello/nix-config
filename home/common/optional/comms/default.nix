{ lib, pkgs, ... }:
{
  #imports = [ ./foo.nix ];

  home.packages =
    (lib.attrValues {
      inherit (pkgs)
        #telegram-desktop
        discord
        #slack
        ;
    })
    ++ [
      (pkgs.unstable.signal-desktop.override {
        commandLineArgs = "--password-store='gnome-libsecret'";
      })
    ];
}
