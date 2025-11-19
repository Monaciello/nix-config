#FIXME(firefox): modularize firefox and decide where this goes
{ config, ... }:
let
  homeDir = config.home.homeDirectory;
in
{
  programs.firefox.profiles.main = {
    id = 0;
    name = "EmergentMind";
    isDefault = true;

    settings = {
      "signon.rememberSignons" = false; # Disable built-in password manager
      "browser.compactmode.show" = true;
      "browser.uidensity" = 1; # enable compact mode
      "browser.aboutConfig.showWarning" = false;
      "browser.download.dir" = "${homeDir}/downloads";

      "browser.tabs.firefox-view" = true; # Sync tabs across devices
      "ui.systemUsesDarkTheme" = 1; # force dark theme
      "extensions.pocket.enabled" = false;
    };
    # This just uses the default suggestion from home-manager for now
    userChrome = ''
      /* Hide tab bar in FF Quantum */
      @-moz-document url("chrome://browser/content/browser.xul") {
        #TabsToolbar {
          visibility: collapse !important;
          margin-bottom: 21px !important;
        }

        #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
          visibility: collapse !important;
        }
      }
    '';
  };

}
