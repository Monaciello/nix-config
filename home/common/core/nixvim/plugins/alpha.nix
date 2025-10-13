{ config, lib, ... }:
{
  options = {
    nixvim-config.plugins.alpha.enable = lib.mkEnableOption "enables alpha module";
  };

  config = lib.mkIf config.nixvim-config.plugins.alpha.enable {
    programs.nixvim.plugins = {
      web-devicons.enable = true; # Required for plugins.alpha
      alpha = {
        enable = true;
        #TODO(rice): redo this in lua to take advantage of tables or maybe there is a way to do in nix
        #example alpha themes: https://github.com/goolord/alpha-nvim/discussions/16
        layout = [
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            opts = {
              position = "center";
              hl = "type";
            };
            val = [
              ""
              "                            *                             "
              "                            *                             "
              "                            *                             "
              "                            **                            "
              "                            **                            "
              "                            **                            "
              "                            **                            "
              "                            **                            "
              "                            **                            "
              "                           ****                           "
              "                           ****                           "
              "                           ****                           "
              "                           ****                           "
              "                           ****                           "
              "                           ****                           "
              "                           ****                           "
              "                           ****                           "
              "                           ****                           "
              "                           ****                           "
              "                          *****                           "
              "                         ****                             "
              "                       *****                              "
              "                      ****                                "
              "                    ****                                  "
              "                  *****************                       "
              "                 *******************                      "
              "               ****               ****                    "
              "              ***                  ****                   "
              "            ****                    ****                  "
              "           ****                      ****                 "
              "         ****                         ****                "
              "        ****                            ***               "
              "       ***                               ****             "
              "     ***                                  ****            "
              "    **                                     ****           "
              "   *                                        ****          "
              " *                                           ****         "
              "                                               ***        "
              "                                                ***       "
              "                                                 ***      "
              "                                                  ***     "
              "                                                    **    "
              "                                                     **   "
              "                                                       *  "
              "                                                        * "
              "                                                         *"
              ""
            ];
          }
          {
            type = "padding";
            val = 4;
          }
          {
            #NOTE: No actions assigned to buttons. Learn the commands.
            type = "group";
            val = [
              {
                type = "button";
                val = "  New file   ";
                opts = {
                  shortcut = "                   <Leader>ene  ";
                  position = "center";
                  width = "60";
                };
              }
              {
                type = "text";
                val = "   Telescope ";
                opts = {
                  hl = "Keyword";
                  position = "center";
                };
              }
              {
                type = "button";
                val = "  File files   ";
                opts = {
                  shortcut = "                   <Leader>ff  ";
                  position = "center";
                  width = "60";
                };
              }
              {
                type = "button";
                val = "  Buffers   ";
                opts = {
                  shortcut = "                   <Leader>fb  ";
                  position = "center";
                  width = "60";
                };
              }
              {
                type = "button";
                val = "  Live grep               ";
                opts = {
                  shortcut = "                   <Leader>fg  ";
                  position = "center";
                  width = "60";
                };
              }
              {
                type = "button";
                val = "  TODOTelescope           ";
                opts = {
                  shortcut = "                   <Leader>ft  ";
                  position = "center";
                  width = "60";
                };
              }
              #NOTE: not used
              #{
              #  type = "button";
              #  val = "  repo list               ";
              #  opts = {
              #    shortcut = "                   <Leader>fr  ";
              #    position = "center";
              #  };
              #}
              {
                type = "button";
                val = "󰮥  Help tags               ";
                opts = {
                  shortcut = "                   <Leader>fh  ";
                  position = "center";
                  width = "60";
                };
              }
              {
                type = "text";
                val = "   git       ";
                opts = {
                  hl = "Keyword";
                  position = "center";
                };
              }
              {
                type = "button";
                val = "   fugitive                ";
                opts = {
                  shortcut = "                 <leader>gs  ";
                  position = "center";
                  width = "60";
                };
              }
              {
                type = "button";
                val = "   Neogit                  ";
                opts = {
                  shortcut = "                 <leader>gg  ";
                  position = "center";
                  width = "60";
                };
              }
              {
                type = "padding";
                val = 1;
              }
              {
                type = "button";
                val = "  Quit Neovim             ";
                opts = {
                  shortcut = "                           :q  ";
                  position = "center";
                };
              }
            ];
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            val = "The way out is through.";
            opts = {
              hl = "Keyword";
              position = "center";
            };
          }
        ];
      };
    };
  };
}
