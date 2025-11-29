#############################################################
#
#  Gusto - Home Theatre
#  NixOS running on Intel N95 based mini PC
#
###############################################################

{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs-impermanence-disk.nix")
    {
      _module.args = {
        disk = "/dev/nvme0n1";
        withSwap = true;
        swapSize = 8;
      };
    }

    #
    # ========== Modules ==========
    #
    (map lib.custom.relativeToRoot (
      # ========== Required modules ==========
      [
        "hosts/common/core"
      ]
      ++
        # ========== Optional common modules ==========
        (map (f: "hosts/common/optional/${f}") [
          # Desktop environment and login manager
          "services/sddm.nix"
          "gnome.nix"

          # Services
          "services/openssh.nix" # allow remote SSH access

          # Network Mgmt
          #FIXME: replace with NFS
          #"smbclient.nix" # mount the ghost mediashare

          # Misc
          "audio.nix" # pipewire and cli controls
          "plymouth.nix" # boot graphics
          "fonts.nix" # fonts
          "vlc.nix" # media player
        ])
    ))
  ];

  #
  # ========== Host Specification ==========
  #
  hostSpec = {
    hostName = "gusto";
    users = lib.mkForce [
      "ta"
      "media"
    ];
    primaryUsername = lib.mkForce "ta";
    primaryDesktopUsername = lib.mkForce "media";

    persistFolder = lib.mkForce "/persist";

    # System type flags
    isWork = lib.mkForce false;
    isProduction = lib.mkForce true;
    isRemote = lib.mkForce true;

    # Functionality
    useYubikey = lib.mkForce true;

    # Graphical
    defaultDesktop = "gnome";
    useWayland = lib.mkForce true;
    isAutoStyled = lib.mkForce true;
    theme = lib.mkForce "rose-pine-moon";
    wallpaper = "${inputs.nix-assets}/images/wallpapers/deco/ad-01.jpg";
  };

  boot.loader.systemd-boot = {
    enable = true;
    # When using plymouth, initrd can expand by a lot each time, so limit how
    # many we keep around
    configurationLimit = lib.mkDefault 10;
    consoleMode = "max";
  };
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };
  boot.initrd.systemd.enable = true;

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # ========== Auto-login as regular user ==========
  services.displayManager.autoLogin = {
    enable = lib.mkForce true;
    user = lib.mkForce "media";
  };
  services.displayManager.sddm.autoLogin = {
    relogin = true;
  };

  sops = {
    secrets = {
      "keys/ssh/ed25519" = {
        # User/group created by the autosshTunnel module
        owner = "autossh";
        group = "autossh";
        path = "/etc/ssh/id_ed25519";
      };
      "keys/ssh/ed25519_pub" = {
        owner = "autossh";
        group = "autossh";
        path = "/etc/ssh/id_ed25519.pub";
      };
    };
  };

  # ========== autosshTunnel ==========
  tunnels.cakes.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.05";
}
