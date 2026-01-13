{ lib, pkgs, ... }:
{
  home.packages = lib.attrValues {
    inherit (pkgs)
      # Development
      tokei

      # Device imaging
      #rpi-imager
      #etcher #was disabled in nixpkgs due to dependency on insecure version of Electron

      # Productivity
      drawio
      libreoffice

      # Web sites
      zola

      # Media production
      audacity
      gimp
      inkscape
      # VM and RDP
      # remmina
      ;

    inherit (pkgs.unstable)
      obs-studio
      grimblast # screenshot tool
      ;
    inherit (pkgs.unstable.pkgsRocm)
      blender
      ;
  };

  # home.packages = [
  #   (pkgs.writeShellScriptBin "flameshot-gui" ''
  #     export XDG_SESSION_TYPE=x11
  #     # export XDG_SESSION_TYPE=wayland
  #     # export QT_QPA_PLATFORM=wayland
  #     # export QT_AUTO_SCREEN_SCALE_FACTOR=0.5
  #     ${lib.getExe' pkgs.flameshot "flameshot"} gui
  #   '')
  # ];

  # services.flameshot = {
  #   enable = true;
  #   package = pkgs.unstable.flameshot;
  #   settings = {
  #     General = {
  #       useGrimAdapter = true;
  #       disabledTrayIcon = false;
  #       showStartupLaunchMessage = true;
  #       showAbortNotification = true;
  #       historyConfirmationToDelete = false;
  #       showHelp = false;
  #       showMagnifier = true;
  #       showSidePanelButton = false;
  #       #        uiColor = "#0f111b";
  #       #        drawColor = "#D81E5B";
  #       drawThickness = 4;
  #
  #       # Save/Export.
  #       copyPathAfterSave = true;
  #     };
  #   };
  # };
  #Disabled for now. grimblast
  #  services.flameshot = {
  #    enable = true;
  #    #       package = pkgsflameshotGrim;
  #  };
}
