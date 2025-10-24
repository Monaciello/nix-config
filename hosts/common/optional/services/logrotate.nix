{ config, ... }:
{
  services.logrotate = {
    enable = true;
    settings = {
      "/run/user/*/hypr/*/hyprland.log" = {
        size = "1G";
        rotate = 5;
        frequency = "daily";
        copytruncate = true; # maintain the original file so hyprland still logs to it
        compress = true; # gzip compression by default
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
