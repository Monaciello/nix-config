{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = lib.flatten [
    # INTRODUS GLUE (home lane of anatomy_v5 / drawio): one HM module set so the
    # same user environment lands on alice workstation, nuc sessions, and (via
    # darwin HM) macbook — host files only pick optional desktops/comms/etc.
    inputs.introdus.homeManagerModules.default
    (map lib.custom.relativeToRoot [
      "modules/home"
    ])
    (lib.custom.scanPathsFilterPlatform ./.)
  ];

  # INTRODUS GLUE / FIXME: hosts/common/users passes hostSpec into HM; introdus
  # should be the stable bridge for "fleet user core" (git/ssh/shell/editor) so
  # we stop duplicating glue between this file and per-host home/*.nix profiles.
  # inherit common modules passed through from hosts
  # be sure to import the respective module above as well
  # see hosts/common/users/default.nix

  #FIXME: move to xdg module
  home.preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported

  home.packages = lib.attrValues {
    inherit (pkgs)

      # Packages that don't have custom configs go here
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
