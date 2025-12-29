#############################################################
#
#  Genoa - Laptop
#  NixOS running on Lenovo Thinkpad E15
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
    (lib.custom.scanPaths ./.) # Load all extra host-specific *.nix files

    # FIXME: Seems this is still needed for Fn keys to work?
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e15-intel

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
          "nfs-ghost-mediashare.nix" # mount the ghost mediashare

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

  boot.initrd = {
    systemd.enable = true;
    kernelModules = [
    ];
  };
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

  #Firmwareupdater
  #  $ fwupdmgr update
  services.fwupd.enable = true;
}
