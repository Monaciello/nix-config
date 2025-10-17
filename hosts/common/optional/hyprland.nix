{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
  };

  environment.systemPackages = [
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  assertions = [
    {
      assertion =
        config.programs.hyprland.package
        == config.home-manager.users.${config.hostSpec.primaryUsername}.wayland.windowManager.hyprland.package;
      message = "NixOS and Home-manager Hyprland package must be the same version.";
    }
    {
      assertion = (
        lib.strings.compareVersions config.hardware.graphics.package.version "25.2.0" == -1
        || lib.strings.compareVersions config.programs.hyprland.package.version "0.51.0" != -1
      ); # Compare two strings representing versions and return -1 if version s1 is older than version s2, 0 if they are the same, and 1 if s1 is newer than s2.
      message = "Mesa 25.2.x has breaking ABI change, Hyprland 0.51.0 or newer is required.";
    }
  ];

}
