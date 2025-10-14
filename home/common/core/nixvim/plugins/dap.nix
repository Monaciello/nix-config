# Debug Adapter Protocol
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.dap.enable = lib.mkEnableOption "enables Debug Adapter Protocol client";
  };

  config = lib.mkIf config.nixvim-config.plugins.dap.enable {
    programs.nixvim.plugins = {
      dap = {
        enable = true;
      };
    };
  };
}
