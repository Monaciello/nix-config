#FIXME: if pulling in homemanager for isMinimal maybe set up conditional for some packages
{
  osConfig,
  lib,
  pkgs,
  hostSpec,
  monitors,
  inputs,
  ...
}:
{
  imports = lib.flatten [
    inputs.introdus.homeManagerModules.default
    (map lib.custom.relativeToRoot [
      "modules/common"
      "modules/home"
    ])
    (lib.custom.scanPathsFilterPlatform ./.)
  ];

  # FIXME: better way of handling the glue for this ?
  # inherit common modules passed through from hosts
  # be sure to import the respective module above as well
  # see hosts/common/users/default.nix
  inherit hostSpec monitors;

  home = {
    username = lib.mkDefault osConfig.hostSpec.username;
    homeDirectory = lib.mkDefault osConfig.hostSpec.home;
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];
    sessionVariables = {
      FLAKE = "$HOME/src/nix/nix-config";
      SHELL = "zsh";
      TERM = "ghostty";
      TERMINAL = "ghostty";
      VISUAL = "nvim";
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
    preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported

  };

  home.packages = lib.attrValues {
    inherit (pkgs)

      # Packages that don't have custom configs go here
      copyq # clipboard manager
      coreutils # basic gnu utils
      curl
      eza # ls replacement
      dust # disk usage
      fd # tree style ls
      findutils # find
      jq # json pretty printer and manipulator
      nix-tree # nix package tree viewer
      neofetch # fancier system info than pfetch
      ncdu # TUI disk usage
      pciutils
      pfetch # system info
      pre-commit # git hooks
      p7zip # compression & encryption
      ripgrep # better grep
      steam-run # for running non-NixOS-packaged binaries on Nix
      usbutils
      tree # cli dir tree viewer
      unzip # zip extraction
      unrar # rar extraction
      wev # show wayland events. also handy for detecting keypress codes
      wget # downloader
      xdg-utils # provide cli tools such as `xdg-mime` and `xdg-open`
      xdg-user-dirs
      yq-go # yaml pretty printer and manipulator
      zip # zip compression
      ;
    inherit (pkgs.introdus)
      jq5 # json5-capable jq
      ;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
