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
          ;
        inherit (pkgs.unstable.nerd-fonts)
          fira-mono
          iosevka
          jetbrains-mono
          symbols-only
          ;
      }
    );
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = [
        "Noto Color Emoji"
        "Iosevka Nerd Font Mono"
        "Nerd Fonts Symbols Only"
      ];
      sansSerif = [
        "Noto Color Emoji"
        "Nerd Fonts Symbols Only"
        "FiraMono Nerd Font Mono"
      ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Color Emoji"
        "Iosevka Nerd Font Mono"
        "Nerd Fonts Symbols Only"
        "FiraMono Nerd Font Mono"
      ];
      emoji = [
        "Noto Color Emoji"
        "Nerd Fonts Symbols Only"
      ];
    };
  };
}
