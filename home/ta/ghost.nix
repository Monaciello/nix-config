{ lib, ... }:
{
  imports = (
    map lib.custom.relativeToRoot (
      [
        #
        # ========== Required Configs ==========
        #
        #FIXME: after fixing user/home values in HM
        "home/common/core"
        "home/common/core/nixos.nix"

        "home/ta/common/nixos.nix"
      ]
      ++
        #
        # ========== Host-specific Optional Configs ==========
        #
        (map (f: "home/common/optional/${f}") [
          "browsers"
          "comms"
          "desktops" # default is hyprland
          "development"
          "gaming"
          "helper-scripts"
          "tools"
          "zellij"

          "atuin.nix"
          "ebooks.nix"
          "media.nix"
          "xdg.nix"
          "sops.nix"
          "yazi.nix"
        ])
    )
  );

  introdus.services.awww = {
    enable = true;
    wallpaperDir = "/home/ta/sync/wallpaper/";
  };

  services.yubikey-touch-detector = {
    enable = true;
    notificationSound = true;
  };
}
