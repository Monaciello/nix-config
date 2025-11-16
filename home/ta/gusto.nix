{ lib, ... }:
{
  imports = (
    map lib.custom.relativeToRoot (
      [
        # ========== Required common modules ==========
        # FIXME: after fixing user/home values in HM
        "home/common/core"
        "home/common/core/nixos.nix"

        "home/ta/common/nixos.nix"
      ]
      ++
        # ========== Optional modules==========
        (map (f: "home/common/optional/${f}") [
          "browsers/brave.nix" # for testing against 'media' user
          "browsers/firefox.nix" # for testing against 'media' user
          "helper-scripts"

          "atuin.nix"
          "sops.nix"
          "xdg.nix" # file associations
        ])
    )
  );

  services.yubikey-touch-detector.enable = true;
  services.yubikey-touch-detector.notificationSound = true;
}
