{ config, lib, ... }:
{
  # swap meta and left alt on laptop keyboard to match moonlander
  services.keyd.keyboards.default = lib.optionalAttrs config.services.keyd.enable {
    ids = [ "17aa:5054" ]; # device id for "thinkpad extra keys" keyboard
    settings.main = {
      leftmeta = "leftalt";
      leftalt = "leftmeta";
    };
  };
}
