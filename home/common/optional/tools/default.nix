{ pkgs, ... }:
{
  #imports = [ ./foo.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      # Development
      tokei

      # Device imaging
      rpi-imager
      #etcher #was disabled in nixpkgs due to dependency on insecure version of Electron

      # Productivity
      drawio

      #FIXME: stable grimblast requires stably hyprland. need unstable grimblast or better yet, see if flameshot works for multimmonitors yet. not working with unstable hyprlan
      #grimblast
      libreoffice

      # Privacy
      #veracrypt
      #keepassxc

      # Web sites
      zola

      # Media production
      audacity
      blender-hip # -hip variant includes h/w accelrated rendering with AMD RNDA gpus
      gimp
      inkscape
      obs-studio
      # VM and RDP
      # remmina
      ;
  };
  #Disabled for now. grimblast
  #  services.flameshot = {
  #      enable = true;
  #     package = flameshotGrim;
  #  };
}
