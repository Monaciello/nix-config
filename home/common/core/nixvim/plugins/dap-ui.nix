# DAP ui
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.dap-ui.enable = lib.mkEnableOption "enables DAB ui";
  };

  config = lib.mkIf config.nixvim-config.plugins.dap-ui.enable {
    programs.nixvim.plugins = {
      dap-ui = {
        enable = true;
      };
    };
  };
}
