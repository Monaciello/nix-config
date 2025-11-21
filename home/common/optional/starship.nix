{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
    enableTransience = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      format = ''
        [ ](magenta)$username$hostname$os$directory $git_branch$git_commit$git_state$git_metrics$git_status$nix_shell[ ](magenta)$fill[ ](magenta)$cmd_duration$time[ ](magenta)
        $character$sudo
      '';
      character = {
        format = "$symbol";
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[V](bold blue)";
        disabled = false;
      };
      cmd_duration = {
        disabled = false;
        min_time = 250;
        show_milliseconds = false;
        show_notifications = false;
        format = "[$duration](grey) ";
      };
      directory = {
        home_symbol = "~";
        truncation_length = 8;
        truncation_symbol = "…/";
        # read_only = " △";
        read_only_style = "red";
        style = "blue";
        truncate_to_repo = false;
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)";
        before_repo_root_style = "";
        repo_root_style = "(bold blue)";

        use_os_path_sep = true;
      };
      direnv = {
        disabled = false;
      };
      fill = {
        symbol = " ";
      };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = "[ ](green)";
        style = "green";
      };
      git_status = {
        #"[△](green)";

        format = "($ahead_behind$staged$renamed$modified$untracked$deleted$conflicted$stashed)";
        conflicted = "[◪$count ](red)";
        # conflicted = "[~$count](red)";

        ahead = "[▲[$count ](green) ](green)";
        #ahead = "[⇡[$count ](green) ](green)";

        behind = "[▼[$count ](green) ](green)";
        # behind = "[⇣[$count ](green) ](green)";

        diverged = "[◇[$ahead_count ](bold green)/[$behind_count](bold red) ](orange)";

        untracked = "[?$count ](yellow)";
        stashed = "[*$count ](bold purple)";

        #modified = "[●$count ](yellow)";
        modified = "[!$count ](yellow)";

        # renamed = "[●$count ](blue)";
        renamed = "[»$count ](cyan)";

        # staged = "[●$count ](bright-cyan)";
        staged = "[+$count ](blue)";
        deleted = "[✕$count ](darkred)";
      };
      hostname = {
        disabled = false;
        ssh_only = true;
        format = "[@$hostname]($style)";
        style = "grey";
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
        format = "[($name)]($style) ";
        style = "grey";
      };
      sudo = {
        format = "[$symbol]($style)";
        style = "red";
        symbol = "#";
        disabled = false;
      };
      time = {
        disabled = false;
        format = "$time";
        time_format = "%y.%m.%d{%H:%M:%S}";
      };
      username = {
        disabled = false;
        style_user = "grey";
        style_root = "red bold";
        format = "[$user]($style) ▻ ";
        show_always = false;
      };
    };
  };
}
