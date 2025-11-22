# FIXME: very ascendancy-centric colour customizations atm; modularize with defaults for introdus and allow per user/host optionals

{ config, pkgs, ... }:
let
  # HACK: needs assert autostyling and optionalize...  currently have to comment out when binds not used because linting
  # Bind base16 theme colors to custom vars so we're not restricted to starship's limited named-color tooling,
  # that inherits from the theme but is limited to only 8 colors
  # darkestBackground = "#${config.lib.stylix.colors.base00}";     # ----      background
  darkBackground = "#${config.lib.stylix.colors.base01}"; # ---       lighter background status bar
  # lightBackground = "#${config.lib.stylix.colors.base02}";       # --        selection background
  # lightestBackground = "#${config.lib.stylix.colors.base03}";    # -         Comments, Invisibles, Line highlighting
  # darkestForeground = "#${config.lib.stylix.colors.base04}";     # +         dark foreground status bar
  # darkForeground = "#${config.lib.stylix.colors.base05}";        # ++        foreground, caret, delimiters, operators
  # lightForeground = "#${config.lib.stylix.colors.base06}";       # +++       light foreground, rarely used
  # lightestForeground = "#${config.lib.stylix.colors.base07}";    # ++++      lightest foreground, rarely used
  # red = "#${config.lib.stylix.colors.base08}";                   # red       vars, xml tags, markup link text, markup lists, diff deleted
  # orange = "#${config.lib.stylix.colors.base09}";                # orange    Integers, Boolean, Constants, XML Attributes, Markup Link Url
  # yellow = "#${config.lib.stylix.colors.base0A}";                # yellow    Classes, Markup Bold, Search Text Background
  # green = "#${config.lib.stylix.colors.base0B}";                 # green     Strings, Inherited Class, Markup Code, Diff Inserted
  # cyan = "#${config.lib.stylix.colors.base0C}";                  # cyan      Support, Regular Expressions, Escape Characters, Markup Quotes
  # blue = "#${config.lib.stylix.colors.base0D}";                  # blue      Functions, Methods, Attribute IDs, Headings
  # purple = "#${config.lib.stylix.colors.base0E}";                # purple    Keywords, Storage, Selector, Markup Italic, Diff Changed
  darkred = "#${config.lib.stylix.colors.base0F}"; # darkred   Deprecated Highlighting for Methods and Functions, Opening/Closing Embedded Language Tags

  # offThemeGreen = "#5fd700 ";
  # offThemeRed = "#ff0000 ";
  # offThemeBlue = "#";
in
{
  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
    enableZshIntegration = true;
    #Not supported for zsh out of the box, see customization in home/common/core/zsh
    enableTransience = true;

    settings = {
      add_newline = true;

      # some dressing options for ref
      #░▒▓
      #▓▒░
      #
      #
      format = ''
        [░▒▓](${darkBackground})$os$username$hostname$directory$git_branch$git_commit$git_state$git_metrics$git_status$nix_shell[▓▒░](${darkBackground})$fill[░▒▓](${darkBackground})$cmd_duration$time[▓▒░](${darkBackground})
        $character
      '';
      character = {
        format = "$symbol";
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[V](bold blue)";
        disabled = false;
      };
      cmd_duration = {
        format = "[$duration ]($style)";
        style = "bg:${darkBackground} fg:white";
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
        style = "bold bg:${darkBackground} fg:blue";
        read_only_style = "bg:${darkBackground} fg:blue dimmed";

        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path ]($style)[$read_only ]($read_only_style)";
        before_repo_root_style = "bg:${darkBackground} fg:blue";
        repo_root_style = "bold bg:${darkBackground} fg:blue";

        use_os_path_sep = true;
      };
      direnv = {
        disabled = false;
      };
      fill = {
        symbol = " ";
      };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch) ]($style)";
        symbol = "[ ](bg:${darkBackground} fg:green)";
        style = "bg:${darkBackground} fg:green";
      };
      git_status = {
        format = "($ahead_behind$staged$renamed$modified$untracked$deleted$conflicted$stashed)";
        style = "bg:${darkBackground} fg:green";

        conflicted = "[~$count ](bg:${darkBackground} fg:orange)";
        ahead = "[▲[$count ](bg:${darkBackground} fg:green)](bg:${darkBackground} fg:green)";
        behind = "[▼[$count ](bg:${darkBackground} fg:green)](bg:${darkBackground} fg:green)";
        diverged = "[◇[$ahead_count](bold bg:${darkBackground} fg:green)/[$behind_count ](bold bg:${darkBackground} fg:red) ](bg:${darkBackground} fg:orange)";
        untracked = "[?$count ](bg:${darkBackground} fg:yellow)";
        stashed = "[*$count ](bold bg:${darkBackground} fg:purple)";
        modified = "[!$count ](bg:${darkBackground} fg:yellow)";
        renamed = "[r$count ](bg:${darkBackground} fg:cyan)";
        staged = "[+$count ](bg:${darkBackground} fg:blue)";
        deleted = "[-$count ](bg:${darkBackground} fg:red)";
      };
      hostname = {
        disabled = false;
        ssh_only = true;
        format = "[@$hostname]($style)";
        style = "bg:${darkBackground} fg:${purple}";
      };
      nix_shell = {
        disabled = true;
        heuristic = false;
        format = "[   $state $name](fg:blue bold)";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "";
      };
      os = {
        disabled = false;
        format = "[($name) ]($style)";
        style = "bg:${darkBackground} fg:${darkred}";
      };
      # when enabled this indicates when sudo creds are cached or not
      # sudo = {
      #   format = "[$symbol]($style)";
      #   style = "red";
      #   symbol = "#";
      #   disabled = false;
      # };
      time = {
        disabled = false;
        format = "[$time]($style)";
        style = "bg:${darkBackground} fg:${darkred}";
        time_format = "%y.%m.%d - %H:%M:%S";
      };
      username = {
        disabled = false;
        show_always = false;
        format = "[$user]($style)";
        style_user = "bg:${darkBackground} fg:grey";
        style_root = "bold bg:${darkBackground} fg:red";
      };
    };
  };
}
