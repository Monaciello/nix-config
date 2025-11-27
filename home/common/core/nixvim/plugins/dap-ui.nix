# DAP ui
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.dap-ui.enable = lib.mkEnableOption "enables DAB ui";
  };

  config = lib.mkIf config.nixvim-config.plugins.dap-ui.enable {
    programs.nixvim = {
      plugins = {
        dap-ui.enable = true;
      };
      keymaps = [
        {
          mode = [ "n" ];
          key = "<leader>bu";
          action = config.lib.nixvim.mkRaw ''
            function()
            require('dap.ext.vscode').load_launchjs(nil,{})
            require("dapui").toggle()
            end
          '';
          options = {
            desc = "DAP- ui";
            silent = true;
          };
        }
      ];
    };
  };
}
