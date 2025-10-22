{ config, ... }:
{
  services.logrotate = {
    enable = true;
    settings = {
      "/run/user/*/hypr/*/hyprland.log" = {
        size = "1000M";
        rotate = 5;
        compress = true; # gzip compression by default
        nocompress = true; # don't compress the newest file
        missingok = true; # don't scream if the file is missing
        notifempty = true; # don't rotate empty files
        dateext = true; # timestamp files
      };
    };
  };
  assertions = [
    {
      assertion = (config.programs.hyprland.enable == true);
      message = "hyprland.log rotation expects that hyprland is enabled.";
    }
  ];

}
