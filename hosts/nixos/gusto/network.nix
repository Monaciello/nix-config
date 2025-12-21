{ config, ... }:
{
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  wifi = {
    enable = true;
    roaming = config.hostSpec.isRoaming;
  };
}
