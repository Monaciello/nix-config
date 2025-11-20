#############################################################
#
#  Genoa - Laptop
#  NixOS running on Lenovo Thinkpad E15
#
###############################################################

{
  config,
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

    # FIXME: Seems this is still needed for Fn keys to work?
    inputs.hardware.nixosModules.lenovo-thinkpad-e15-intel

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs-luks-impermanence-disk.nix")
    {
      _module.args = {
        disk = "/dev/nvme0n1";
        withSwap = true;
        swapSize = 16;
      };
    }

    #
    # ========== Modules ==========
    #
    (map lib.custom.relativeToRoot (
      # ========== Required modules==========
      [
        "hosts/common/core"
      ]
      ++
        # ========== Optional common modules ==========
        (map (f: "hosts/common/optional/${f}") [
          # Desktop environment and login manager
          "services/sddm.nix"
          "hyprland.nix" # window manager

          # Services
          "services/bluetooth.nix" # bluetooth, blueman and bluez via wireplumber
          "services/openssh.nix" # allow remote SSH access
          "services/printing.nix" # CUPS

          # Network Mgmt and
          "smbclient.nix" # mount the ghost mediashare

          # Misc
          "audio.nix" # pipewire and cli controls
          "gaming.nix" # window manager
          "fonts.nix" # fonts
          "nvtop.nix" # GPU monitor (not available in home-manager)
          "obsidian.nix" # wiki
          "plymouth.nix" # boot graphics
          "protonvpn.nix" # vpn
          "thunar.nix" # gui file manager
          "wayland.nix" # wayland components and pkgs not available in home-manager
          "vlc.nix" # media player
          "yubikey.nix" # yubikey related packages and configs
        ])
    ))
  ];

  #
  # ========== Host Specification ==========
  #
  hostSpec = {
    hostName = "genoa";
    primaryUsername = lib.mkForce "ta";

    persistFolder = "/persist"; # added for "completion" because of the disko spec that was used even though impermanence isn't actually enabled here yet.

    # System type flags
    isRemote = lib.mkForce false; # not remotely managed
    isRoaming = lib.mkForce true;

    # Functionality
    useYubikey = lib.mkForce true;

    # Graphical
    theme = lib.mkForce "darcula";
    wallpaper = "${inputs.nix-assets}/images/wallpapers/zen-02.jpg";
    isAutoStyled = lib.mkForce true;
    hdr = lib.mkForce true;
  };

  #
  # ========== Keyboard Remaps ==========
  #
  # swap meta and left alt on laptop keyboard to match moonlander
  services.keyd.keyboards.default = lib.optionalAttrs config.services.keyd.enable {
    ids = [ "17aa:5054" ]; # device id for "thinkpad extra keys" keyboard
    settings.main = {
      leftmeta = "leftalt";
      leftalt = "leftmeta";
    };
  };

  #
  # ========== Network ==========
  #
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };
  wifi = {
    enable = true;
    roaming = config.hostSpec.isRoaming;
  };

  #Firmwareupdate
  #  $ fwupdmgr update
  services.fwupd.enable = true;

  #  services.backup = {
  #    enable = true;
  #    borgBackupStartTime = "02:00:00";
  #    borgServer = "${config.hostSpec.networking.subnets.grove.hosts.oops.ip}";
  #    borgUser = "${config.hostSpec.username}";
  #    borgPort = "${builtins.toString config.hostSpec.networking.ports.tcp.oops}";
  #    borgBackupPath = "/var/services/homes/${config.hostSpec.username}/backups";
  #    borgNotifyFrom = "${config.hostSpec.email.notifier}";
  #    borgNotifyTo = "${config.hostSpec.email.backup}";
  #  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      # When using plymouth, initrd can expand by a lot each time, so limit how many we keep around
      configurationLimit = lib.mkDefault 10;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
    timeout = 5;
  };

  boot.initrd = {
    systemd.enable = true;
    kernelModules = [
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.05";
}
