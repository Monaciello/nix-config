{ inputs, lib, ... }:
{
  hostSpec = {
    hostName = "genoa";
    users = lib.mkForce [
      "ta"
    ];

    persistFolder = "/persist"; # added for "completion" because of the disko spec that was used even though impermanence isn't actually enabled here yet.

    # System type flags
    isAdmin = lib.mkForce true;
    isRemote = lib.mkForce false; # not remotely managed
    isRoaming = lib.mkForce true;

    # Functionality
    useYubikey = lib.mkForce true;

    # Graphical
    defaultDesktop = "hyprland-uwsm";
    theme = lib.mkForce "darcula";
    wallpaper = "${inputs.nix-assets}/images/wallpapers/zen-02.jpg";
    isAutoStyled = lib.mkForce true;
    hdr = lib.mkForce true;
  };
}
