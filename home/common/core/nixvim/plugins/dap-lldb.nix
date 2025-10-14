# DAP lldb - C, C++, and Rust
{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.dap-lldb.enable = lib.mkEnableOption "enables DAB lldb for C, C++, and Rust";
  };

  config = lib.mkIf config.nixvim-config.plugins.dap-lldb.enable {
    programs.nixvim.plugins = {
      dap-lldb = {
        enable = true;
      };
    };
  };
}
