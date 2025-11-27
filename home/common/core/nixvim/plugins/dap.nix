# Debug Adapter Protocol
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.dap.enable = lib.mkEnableOption "enables Debug Adapter Protocol client";
  };

  config = lib.mkIf config.nixvim-config.plugins.dap.enable {
    programs.nixvim = {
      plugins = {
        dap = {
          enable = true;
        };
      };
      keymaps = [
        {
          mode = [ "n" ];
          key = "<F1>";
          action = "<cmd>lua require('dap').continue()<CR>";
          options = {
            desc = "DAP- continue";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<F2>";
          action = "<cmd>lua require('dap').step_into()<CR>";
          options = {
            desc = "DAP- step into";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<F3>";
          action = "<cmd>lua require('dap').step_over()<CR>";
          options = {
            desc = "DAP- step over";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<F4>";
          action = "<cmd>lua require('dap').step_out()<CR>";
          options = {
            desc = "DAP- step out";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<F5>";
          action = "<cmd>lua require('dap').step_back()<CR>";
          options = {
            desc = "DAP- step back";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<F12>";
          action = "<cmd>lua require('dap').restart()<CR>";
          options = {
            desc = "DAP- restart";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<Leader>bb";
          action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
          options = {
            desc = "DAP- toggle breakpoint";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<Leader>bB";
          action = "<cmd>lua require('dap').set_breakpoint()<CR>";
          options = {
            desc = "DAP- set breakpoint";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<Leader>br";
          action = "<cmd>lua require('dap').run_to_cursor()<CR>";
          options = {
            desc = "DAP- run to cursor";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<Leader>blp";
          action = "<cmd>lua require('dap').set_breakpoint(nil,nil, vim.fn.input('Log point message:')))<CR>";
          options = {
            desc = "DAP- log point";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<Leader>bh";
          action = "<cmd>lua require('dap.ui.widgets').hover()<CR>";
          options = {
            desc = "DAP- hover widgets";
            noremap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<Leader>bp";
          action = "<cmd>lua require('dap.ui.widgets').preview()<CR>";
          options = {
            desc = "DAP- preview widgets";
            noremap = true;
          };
        }
      ];
    };
  };
}
