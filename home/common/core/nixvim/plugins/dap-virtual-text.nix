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
        settings = {
          # Mitigate secrets leakage while recording.
          display_callback = config.lib.nixvim.mkRaw ''
            function(variable)
                local name = string.lower(variable.name)
                local value = string.lower(variable.value)

                if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
                    return "******"
                end

                if #variable.value > 15 then
                   return " " .. string.sub(variable.value, 1, 15) .. "... "
                end
                   return " " .. variable.value
            end,
          '';
        };
      };
    };
  };
}
