{
  pkgs,
  ...
}:
{
  fonts = {
    # WARNING: Disabling enableDefaultPackages will mess up fonts on sites like
    # https://without.boats/blog/pinned-places/ with huge gaps after the ' character
    enableDefaultPackages = true;

    fontDir.enable = true;
    packages = (
      builtins.attrValues {
        inherit (pkgs)
          # icon fonts
          material-design-icons
          font-awesome

          noto-fonts
          noto-fonts-emoji
          # noto-fonts-extra

          source-sans
          source-serif

          # for work
          montserrat
          vista-fonts
          ;
        inherit (pkgs.unstable.nerd-fonts)
          fira-mono
          iosevka
          jetbrains-mono
          symbols-only
          ;
      }
    );
    fontconfig.defaultFonts = {
      serif = [
        "Iosevka Nerd Font Mono"
        "Nerd Fonts Symbols Only"
      ];
      sansSerif = [
        "FiraMono Nerd Font Mono"
        "Nerd Fonts Symbols Only"
      ];
      monospace = [
        "FiraMono Nerd Font Mono"
        "JetBrainsMono Nerd Font"
        "Iosevka Nerd Font Mono"
        "Nerd Fonts Symbols Only"
      ];
      emoji = [
        "Nerd Fonts Symbols Only"
      ];
    };
  };
}
