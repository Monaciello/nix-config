{ config, ... }:
let
  ghostIP = config.hostSpec.networking.subnets.grove.hosts.ghost.ip;
in
{
  # mount nfs mediashare from ghost
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/mediashare" = {
    device = "${ghostIP}:/mnt/extra/mediashare/";
    fsType = "nfs";
  };
}
