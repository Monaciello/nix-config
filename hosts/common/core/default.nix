# IMPORTANT: This is used by NixOS and nix-darwin so options must exist in both!
#
# INTRODUS GLUE (hosts lane of anatomy_v5 / nix-config.drawio):
# Every fleet member (alice, rpi4-0x*, nuc, and later macbook via darwin) should
# enter through this core so overlays land identically. Platform-specific introdus
# modules attach in ./nixos.nix (and a future ./darwin.nix) — keep this file
# cross-platform. Host hardware stays under hosts/<platform>/<name>; shared
# behavior stays here or in introdus (that split enables one workstation → fleet).
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  isDarwin,
  secrets,
  ...
}:
let
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
in
{
  imports = lib.flatten [
    inputs.home-manager.${platformModules}.home-manager
    inputs.sops-nix.${platformModules}.sops
    inputs.disko.${platformModules}.disko
    inputs.nix-index-database.${platformModules}.nix-index
    { programs.nix-index-database.comma.enable = true; } # NOTE: don't enable in hm as well because it will barf eventually

    (map lib.custom.relativeToRoot [
      "modules/common"
      "modules/hosts/common"
      "modules/hosts/${platform}"

      "hosts/common/core/${platform}.nix"
      "hosts/common/core/keyd.nix"
      "hosts/common/core/sops.nix" # Core because it's used for backups, mail
      "hosts/common/core/ssh.nix"

      "hosts/common/users/"
    ])
  ];

  #
  # ========== Core Host Specifications ==========
  #
  hostSpec = {
    primaryUsername = "ta";
    users = [ "ta" ];
    handle = "emergentmind";
    inherit (secrets)
      domain
      email
      userFullName
      networking
      ;
  };

  networking.hostName = config.hostSpec.hostName;

  # System-wide packages, in case we log in as root
  environment.systemPackages = [ pkgs.openssh ];

  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";

  #
  # ========== Overlays ==========
  #
  nixpkgs = {
    overlays = [
      outputs.overlays.default
      # INTRODUS GLUE: pkgs.introdus.* available for rebuild/bootstrap tooling on-box
      inputs.introdus.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  #
  # ========== Basic Shell Enablement ==========
  #
  # On darwin it's important this is outside home-manager
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
}
