{ inputs, lib, ... }:
{
  imports = (
    map lib.custom.relativeToRoot (
      map (f: "home/common/optional/${f}") [
        "browsers/brave.nix"
        "browsers/firefox.nix"
        "networking/protonvpn.nix"

        "xdg.nix"
        "media.nix"
        "yazi.nix"
      ]
    )
  );

  home.packages = builtins.attrValues {

  };

  home.file = {
    # Avatar used by login managers like SDDM (must be PNG)
    ".face.icon".source = "${inputs.nix-assets}/images/avatars/camera.jpg";
  };
}
