# GitSigns
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.gitsigns.enable = lib.mkEnableOption "enables gitsigns git integration for buffers";
  };

  config = lib.mkIf config.nixvim-config.plugins.gitsigns.enable {
    programs.nixvim.plugins = {
      gitsigns = {
        enable = true;
      };
    };
  };
}
