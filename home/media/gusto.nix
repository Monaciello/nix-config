{ lib, ... }:
{
  imports = (
    map lib.custom.relativeToRoot (
      # ========== Required common modules ==========
      # FIXME: remove after fixing user/home values in HM
      [
        "home/common/core"
        "home/common/core/nixos.nix"

        "home/media/common/"
      ]
      # ========== Optional common modules ==========
      ++ (map (f: "home/common/optional/${f}") [
        "desktops/gnome"
      ])
    )
  );

  home.packages = builtins.attrValues {

  };

  # FIXME(firefox): Add extensions
  programs.firefox = {
    policies = {
      DisableFirefoxAccounts = lib.mkForce true;
    };
    profiles.main = {
      id = 1;
      name = "media";
      isDefault = true;
      settings = {
        "ui.systemUsesDarkTheme" = 1; # force dark theme
        "extensions.pocket.enabled" = false;
        # "signon.rememberSignons" = lib.mkForce "false";
        #"layout.css.devPixelsPerPx" = 2.4; # Hi DPI is already 2.0, but extension icons are small on TV
      };
      # Tweaks for Firefox ui/layout
      userChrome = '''';
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "Jellyfin";
                url = "http://localhost:8096";
              }
              {
                name = "Netflix";
                url = "https://www.netflix.com";
              }
              {
                name = "Crave";
                url = "https://www.crave.ca";
              }
              {
                name = "Prime";
                url = "https://www.primevideo.com";
              }
              {
                name = "YouTube";
                url = "https://www.youtube.com";
              }
            ];
          }
        ];
      };
    };
  };

  # # Keep firefox running if it's closed
  # systemd.user.services.firefox = {
  #   Unit = {
  #     description = "Firefox Browser";
  #     After = [
  #       "graphical-session.target"
  #       "graphical-session-pre.target"
  #     ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Install.WantedBy = [ "graphical-session.target" ];
  #   Service = {
  #     Type = "simple";
  #     ExecStart = "/home/ca/.nix-profile/bin/firefox";
  #     Restart = "always";
  #     RestartSec = 5;
  #   };
  # };
}
