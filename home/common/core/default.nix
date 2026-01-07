{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = lib.flatten [
    inputs.introdus.homeManagerModules.default
    (map lib.custom.relativeToRoot [
      "modules/home"
    ])
    (lib.custom.scanPathsFilterPlatform ./.)
  ];

  # FIXME: better way of handling the glue for this ?
  # inherit common modules passed through from hosts
  # be sure to import the respective module above as well
  # see hosts/common/users/default.nix

  #FIXME: move to xdg module
  home.preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported

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

  programs.home-manager.enable = true;
}
