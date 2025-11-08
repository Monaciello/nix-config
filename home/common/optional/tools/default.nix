{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
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
      blender-hip # -hip variant includes h/w accelrated rendering with AMD RNDA gpus
      grimblast # screenshot tool
      obs-studio
      ;
  };
  #Disabled for now. grimblast
  #  services.flameshot = {
  #    enable = true;
  #    #       package = pkgsflameshotGrim;
  #  };
}
