# Core home functionality that will only work on Darwin
{ osConfig, ... }:
{
  home.sessionPath = [ "/opt/homebrew/bin" ];

  home = {
    username = osConfig.hostSpec.username;
    homeDirectory = osConfig.hostSpec.home;
  };
}
