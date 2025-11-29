#############################################################
#
#  Ghost - Main Desktop
#  NixOS running on Ryzen 9 5900XT, Radeon RX 9070 XT, 64GB RAM
#
###############################################################

{
  inputs,
  lib,
  config,
  pkgs,
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
    (lib.custom.relativeToRoot "hosts/common/disks/ghost.nix")

    #
    # ========== Misc Inputs ==========
    #
    #    inputs.stylix.nixosModules.stylix

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/services/bluetooth.nix" # bluetooth
      "hosts/common/optional/services/sddm.nix" # display manager
      "hosts/common/optional/services/logrotate.nix" # log rotation
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/printing.nix" # CUPS
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/fonts.nix" # fonts
      "hosts/common/optional/libvirt.nix" # vm tools
      "hosts/common/optional/gaming.nix" # steam, gamescope, gamemode, and related hardware
      "hosts/common/optional/gnome.nix" # window manager
      "hosts/common/optional/hyprland.nix" # window manager
      "hosts/common/optional/mail.nix" # for sending email notifications
      "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
      "hosts/common/optional/amdgpu_top.nix" # GPU monitor (not available in home-manager)
      "hosts/common/optional/obsidian.nix" # wiki
      "hosts/common/optional/plymouth.nix" # fancy boot screen
      "hosts/common/optional/protonvpn.nix" # vpn
      "hosts/common/optional/scanning.nix" # SANE and simple-scan
      "hosts/common/optional/thunar.nix" # gui file manager
      "hosts/common/optional/vlc.nix" # media player
      "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager
      "hosts/common/optional/yubikey.nix" # yubikey related packages and configs
      "hosts/common/optional/zsa-keeb.nix" # Moonlander keeb flashing stuff
    ])
    #
    # ========== Ghost Specific ==========
    #
    #TODO: replace with NFS. Disabled because of dependency issues in 25.11 that I don't care to gif on
    #    ./samba.nix

  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "ghost";
    primaryUsername = lib.mkForce "ta";

    persistFolder = "/persist"; # added for "completion" because of the disko spec that was used even though impermanence isn't actually enabled here yet.

    # System type flags
    isWork = lib.mkForce false;
    isProduction = lib.mkForce true;
    isRemote = lib.mkForce true;

    # Functionality
    useYubikey = lib.mkForce true;

    # Graphical
    hdr = lib.mkForce true;
    scaling = "2";
    isAutoStyled = lib.mkForce true;
    #FIXME: not in stylix yet
    #theme = lib.mkForce "ascendancy";
    #wallpaper = ""; # use default since it's overridden by wallpaperDir option for swww settings in home/ta/ghost.nix
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # needed to unlock LUKS on secondary drives
  # use partition UUID
  # https://wiki.nixos.org/wiki/Full_Disk_Encryption#Unlocking_secondary_drives
  environment.etc.crypttab.text = lib.optionalString (!config.hostSpec.isMinimal) ''
    cryptextra UUID=d90345b2-6673-4f8e-a5ef-dc764958ea14 /luks-secondary-unlock.key
    cryptvms UUID=ce5f47f8-d5df-4c96-b2a8-766384780a91 /luks-secondary-unlock.key
  '';

  boot.loader = {
    systemd-boot = {
      enable = true;
      # When using plymouth, initrd can expand by a lot each time, so limit how many we keep around
      configurationLimit = lib.mkDefault 10;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };
  console.earlySetup = lib.mkDefault true;
  boot.initrd = {
    systemd.enable = true;
    kernelModules = [
      "amdgpu"
    ];
  };
  boot = {
    kernelPackages = pkgs.stable.linuxPackages_latest;
    kernelParams = [
      "amdgpu.ppfeaturemask=0xfffd3fff" # https://kernel.org/doc/html/latest/gpu/amdgpu/module-parameters.html#ppfeaturemask-hexint
      "amdgpu.dcdebugmask=0x400" # Allegedly might help with some crashes
      "split_lock_detect=off" # Alleged gaming perf increase
      "amdgpu.modeset=1" # explicitly have driver perform KMS (Kernel Mode Setting) during initialization to get higher resolution console output during boot
    ]
    ++ (builtins.map (
      m:
      "video=${m.name}:${builtins.toString m.width}x${builtins.toString m.height}@${builtins.toString m.refreshRate}"
    ) config.monitors);

    # Fix for XBox controller disconnects
    extraModprobeConfig = ''options bluetooth disable_ertm=1 '';
  };

  hardware = {
    graphics.package = pkgs.unstable.mesa;
    graphics.package32 = pkgs.unstable.pkgsi686Linux.mesa; # force the same mesa for when steams requires separate system32 mesa dep
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.unstable)
      vulkan-tools # vulkaninfo
      ;
  };

  # Connect our NUT client to the UPS on the network
  services.ups = {
    client.enable = true;
    name = "cyberpower";
    username = "nut";
    ip = config.hostSpec.networking.subnets.grove.hosts.moth.ip;
    powerDownTimeOut = (60 * 30); # 30m. UPS reports ~45min
  };

  services.backup = {
    enable = true;
    borgBackupStartTime = "02:00:00";

    borgServer = "${config.hostSpec.networking.subnets.grove.hosts.moth.ip}";
    borgUser = "${config.hostSpec.username}";
    borgPort = "${builtins.toString config.hostSpec.networking.ports.tcp.moth}";

    borgRemotePath = "/run/current-system/sw/bin/borg";

    borgBackupPath = "/mnt/storage/backup/${config.hostSpec.username}";
    borgNotifyFrom = "${config.hostSpec.email.notifier}";
    borgNotifyTo = "${config.hostSpec.email.backup}";
  };

  #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  # If on hyprland, use `hyprctl monitors` to get monitor info.
  # https://wiki.hyprland.org/Configuring/Monitors/
  #           ------
  #        | HDMI-A-1 |
  #           ------
  #  ------   ------   ------
  # | DP-2 | | DP-1 | | DP-3 |
  #  ------   ------   ------
  monitors = [
    {
      name = "DP-2";
      width = 2560;
      height = 2880;
      refreshRate = 60;
      x = -2560;
      workspace = "8";
      scale = config.hostSpec.scaling;
    }
    {
      name = "DP-1";
      width = 3840;
      height = 2160;
      refreshRate = 60;
      vrr = 1;
      primary = true;
      scale = config.hostSpec.scaling;
    }
    {
      name = "DP-3";
      width = 2560;
      height = 2880;
      refreshRate = 60;
      x = 3840;
      workspace = "10";
      scale = config.hostSpec.scaling;
    }
    {
      name = "HDMI-A-1";
      width = 2560;
      height = 1440;
      refreshRate = 144;
      y = -1440;
      transform = 2;
      workspace = "9";
      #scale = config.hostSpec.scaling; #not needed, resolution too low
    }
  ];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
