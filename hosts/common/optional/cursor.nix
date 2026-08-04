{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.code-cursor-nix.packages.${pkgs.stdenv.hostPlatform.system}.cursor
  ];
}
