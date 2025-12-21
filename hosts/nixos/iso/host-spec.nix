{ inputs, lib, ... }:
{
  hostSpec = {

    primaryUsername = "ta";
    username = "ta";
    hostName = "iso";
    isProduction = lib.mkForce false;
    networking = inputs.nix-secrets.networking; # Needed because we don't use host/common/core for iso
  };

}
