# DAP python
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.dap-python.enable = lib.mkEnableOption "enables DAB python";
  };

  config = lib.mkIf config.nixvim-config.plugins.dap-python.enable {
    programs.nixvim.plugins = {
      dap-python = {
        enable = true;
      };
    };
  };
}
