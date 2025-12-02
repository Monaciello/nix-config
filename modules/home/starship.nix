# A heavily opinionated starship module that depends on stylix to improve coloring
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;

  # NOTE: This is the modularized startship not config.programs.starship, which is explicitly defined below.
  cfg = config.starship;

  #TODO: add logic for detecting and using tinted-schemes if
  color_lib = config.lib.stylix.colors;
in
{
  options.starship = {
    enable = lib.mkEnableOption "starship";
    package = lib.mkOption {
      type = types.path;
      default = pkgs.stable.starship;
    };
    base_background = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base00}";
      description = "The darkest _background color. Defaults to base00 as per lib.stylix theme.";
    };
    status_background = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base01}";
      description = "A lighter _background typically used for status bar. Defaults to base01 as per lib.stylix theme.";
    };
    selection_background = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base02}";
      description = "Selection _background. Defaults to base02 as per lib.stylix theme.";
    };
    highlight_background = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base03}";
      description = "Comments, Invisibles, Line highlighting. Defaults to base03 as per lib.stylix theme.";
    };
    status_foreground = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base04}";
      description = "Dark foreground status bar. Defaults to base04 as per lib.stylix theme.";
    };
    base_foreground = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base05}";
      description = "_foreground, caret, delimiters, operators. Defaults to base05 as per lib.stylix theme.";
    };
    light_foreground = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base06}";
      description = "Light foreground, rarely used. Defaults to base06 as per lib.stylix theme.";
    };
    lightest_foreground = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base07}";
      description = "Lightest foreground, rarely used. Defaults to base07 as per lib.stylix theme.";
    };
    red = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base08}";
      description = "Vars, xml tags, markup link text, markup lists, diff deleted. Defaults to base08 as per lib.stylix theme.";
    };
    orange = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base09}";
      description = "Integers, Boolean, Constants, XML Attributes, Markup Link Url. Defaults to base09 as per lib.stylix theme.";
    };
    yellow = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base0A}";
      description = "Classes, Markup Bold, Search Text _background. Defaults to base0A as per lib.stylix theme.";
    };
    green = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base0B}";
      description = "Strings, Inherited Class, Markup Code, Diff Inserted. Defaults to base0B as per lib.stylix theme.";
    };
    cyan = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base0C}";
      description = "Support, Regular Expressions, Escape Characters, Markup Quotes. Defaults to base0C as per lib.stylix theme.";
    };
    blue = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base0D}";
      description = "Functions, Methods, Attribute IDs, Headings. Defaults to base0D as per lib.stylix theme.";
    };
    purple = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base0E}";
      description = "Keywords, Storage, Selector, Markup Italic, Diff Changed. Defaults to base0E as per lib.stylix theme.";
    };
    darkred = mkOption {
      type = types.str;
      example = "#000000";
      default = "#${color_lib.base0F}";
      description = "Deprecated Highlighting for Methods and Functions, Opening/Closing Embedded Language Tags. Defaults to base0F as per lib.stylix theme.";
    };
    left_divider_str = mkOption {
      type = types.str;
      example = "  ";
      default = "";
      description = "Character used for separating starship modules.";
    };
    right_divider_str = mkOption {
      type = types.str;
      example = "  ";
      default = "";
      description = "Character used for separating starship modules.";
    };
    fill_str = mkOption {
      type = types.str;
      example = "·";
      default = " ";
      description = "Character used for separating starship modules.";
    };
  };
  config = mkIf cfg.enable {
    programs.starship =
      let
        left_divider = "[${cfg.left_divider_str}](bg:${cfg.status_background} fg:${cfg.base_foreground})";
        right_divider = "[${cfg.right_divider_str}](bg:${cfg.status_background} fg:${cfg.base_foreground})";
      in
      {
        enable = true;
        package = cfg.package;
        enableZshIntegration = true;
        enableTransience = true; # NOTE: transcience for zsh isn't support out-of-box but we enable at the end of this file
        settings = {
          add_newline = true;

          # some dressing characters for reference
          #╭─   admin@myth  ~ ▓▒░····░▒▓ 󰞑     19:44:14 ─╮
          #░▒▓
          #▓▒░
          #
          #
          format = ''
            [╭─](${cfg.darkred})[](${cfg.status_background})$os${left_divider}$username$hostname${left_divider}$directory${left_divider}$git_branch$git_commit$git_state$git_metrics$git_status[▓▒░](${cfg.status_background})$fill[░▒▓](${cfg.status_background})$status$cmd_duration${right_divider}$nix_shell[](${cfg.status_background})[─╮](${cfg.darkred})
          '';
          character = {
            format = "$symbol";
            success_symbol = "[❯](bold ${cfg.green})";
            error_symbol = "[❯](bold ${cfg.red})";
            vicmd_symbol = "[V](bold ${cfg.blue})";
            disabled = false;
          };
          cmd_duration = {
            format = "[$duration ]($style)";
            style = "bg:${cfg.status_background} fg:${cfg.base_foreground}";
            disabled = false;
            min_time = 250;
            show_milliseconds = false;
            show_notifications = false;
          };
          directory = {
            home_symbol = "~";
            truncation_length = 9;
            truncation_symbol = "…/";
            truncate_to_repo = false;

            format = "[$path ]($style)[$read_only ]($read_only_style)";
            style = "bold bg:${cfg.status_background} fg:${cfg.blue}";
            read_only_style = "bg:${cfg.status_background} fg:${cfg.blue} dimmed";

            repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path ]($style)[$read_only ]($read_only_style)";
            before_repo_root_style = "bg:${cfg.status_background} fg:${cfg.blue}";
            repo_root_style = "bold bg:${cfg.status_background} fg:${cfg.blue}";

            use_os_path_sep = true;
          };
          direnv = {
            disabled = false;
          };
          fill = {
            style = "bg:${cfg.base_background} fg:${cfg.base_foreground}";
            symbol = "${cfg.fill_str}";
          };
          git_branch = {
            format = "[$symbol$branch(:$remote_branch) ]($style)";
            symbol = "[ ](bg:${cfg.status_background} fg:${cfg.green})";
            style = "bg:${cfg.status_background} fg:${cfg.green}";
          };
          git_status = {
            format = "($ahead_behind$staged$renamed$modified$untracked$deleted$conflicted$stashed)";
            style = "bg:${cfg.status_background} fg:${cfg.green}";

            conflicted = "[~$count ](bg:${cfg.status_background} fg:${cfg.orange})";
            ahead = "[▲$count ](bg:${cfg.status_background} fg:${cfg.green})";
            behind = "[▼$count ](bg:${cfg.status_background} fg:${cfg.green})";
            diverged = "[◇[$ahead_count](bold bg:${cfg.status_background} fg:green)/[$behind_count ](bold bg:${cfg.status_background} fg:red) ](bg:${cfg.status_background} fg:orange)";
            untracked = "[?$count ](bg:${cfg.status_background} fg:${cfg.yellow})";
            stashed = "[*$count ](bold bg:${cfg.status_background} fg:${cfg.purple})";
            modified = "[!$count ](bg:${cfg.status_background} fg:${cfg.yellow})";
            renamed = "[r$count ](bg:${cfg.status_background} fg:${cfg.cyan})";
            staged = "[+$count ](bg:${cfg.status_background} fg:${cfg.blue})";
            deleted = "[-$count ](bg:${cfg.status_background} fg:${cfg.red})";
          };
          hostname = {
            disabled = false;
            ssh_only = true;
            format = "[@$hostname]($style)";
            style = "bg:${cfg.status_background} fg:${cfg.purple}";
          };
          nix_shell = {
            disabled = false;
            heuristic = false;
            format = "[  $symbol](bg:${cfg.status_background} fg:${cfg.blue})";
            #symbol = " ";
          };
          os = {
            disabled = false;
            format = "[$symbol ]($style)";
            style = "bg:${cfg.status_background} fg:${cfg.base_foreground}";
          };
          # when enabled this indicates when sudo c${cfg.red}s are cached or not
          # sudo = {
          #   format = "[$symbol]($style)";
          #   style = "${cfg.red}";
          #   symbol = "#";
          #   disabled = false;
          # };
          time = {
            disabled = false;
            format = "[$time]($style)";
            style = "bg:${cfg.status_background} fg:${cfg.darkred}";
            time_format = "%y.%m.%d{%H:%M:%S}";
          };
          status = {
            #FIXME: add pipestatus symbols and styles
            disabled = false;
            format = "[$symbol]($style)";
            symbol = " ";
            success_symbol = "󰞑 ";
            not_execeutable_symbol = " ";
            not_found_symbol = " ";
            sigint_symbol = " ";
            #signal_symbol = "";
            success_style = "bg:${cfg.status_background} fg:${cfg.green}";
            failure_style = "bg:${cfg.status_background} fg:${cfg.red}";
          };
          username = {
            disabled = false;
            show_always = false;
            format = "[$user]($style)";
            style_user = "bg:${cfg.status_background} fg:${cfg.purple}";
            style_root = "bold bg:${cfg.status_background} fg:${cfg.red}";
          };
        };

      };
    # enable transient prompt for Zsh
    programs.zsh.initContent =
      lib.optionalString (config.programs.starship.enable && config.programs.starship.enableTransience)
        ''
          TRANSIENT_PROMPT=$(starship module character)

          function zle-line-init() {
          emulate -L zsh

          [[ $CONTEXT == start ]] || return 0
          while true; do
              zle .recursive-edit
              local -i ret=$?
              [[ $ret == 0 && $KEYS == $'\4' ]] || break
              [[ -o ignore_eof ]] || exit 0
          done

          local saved_prompt=$PROMPT
          local saved_rprompt=$RPROMPT

          PROMPT=$TRANSIENT_PROMPT
          zle .reset-prompt
          PROMPT=$saved_prompt

          if (( ret )); then
              zle .send-break
          else
              zle .accept-line
          fi
          return ret
          }
        '';
  };

}
