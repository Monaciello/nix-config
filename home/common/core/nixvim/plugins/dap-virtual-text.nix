# DAP virtual text support
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.dap-virtual-text.enable = lib.mkEnableOption "enables DAB virtual text";
  };

  config = lib.mkIf config.nixvim-config.plugins.dap-virtual-text.enable {
    programs.nixvim.plugins = {
      dap-virtual-text = {
        enable = true;
      };
    };
  };
}
