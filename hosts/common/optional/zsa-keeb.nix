{ pkgs, ... }:
{
  hardware.keyboard.zsa.enable = true;
  environment.systemPackages = [
    pkgs.unstable.keymapp
  ];
}
