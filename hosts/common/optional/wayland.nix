{ pkgs, ... }:
{
  # general packages related to wayland
  environment.systemPackages = [
    pkgs.grim # screen capture component, required by flameshot
    pkgs.waypaper # wayland packages(nitrogen analog for wayland)
  ];
}
