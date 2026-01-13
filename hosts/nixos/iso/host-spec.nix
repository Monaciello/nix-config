{ secrets, lib, ... }:
{
  hostSpec = {

    primaryUsername = "ta";
    hostName = "iso";
    isProduction = lib.mkForce false;
    networking = secrets.networking; # Needed because we don't use host/common/core for iso
  };

}
