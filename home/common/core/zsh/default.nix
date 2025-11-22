{
  config,
  pkgs,
  lib,
  ...
}:
let
  # transient prompt for zsh in starship
  # there are other ways of doing this that allow customization of the
  # transient prompt in starship config itself but we only use 'character' anyway
  # see here for alternate solution ideas:https://github.com/starship/starship/discussions/5950
  transientPrompt = ''
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
in
{
  #
  # ========= Programs integrated to zsh via option or alias =========
  #

  #Adding these packages here because the are tied to zsh
  home.packages = [
    pkgs.rmtrash # temporarily cache deleted files for recovery
    pkgs.fzf # fuzzy finder used by initExtra.zsh
  ];
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd" # replace cd with z and zi (via cdi)
    ];
  };

  #
  # ========= Actual zsh options =========
  #
  programs.zsh = {
    enable = true;

    # relative to ~
    dotDir = ".config/zsh";
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    autosuggestion.enable = true;
    history.size = 10000;
    history.share = true;

    # NOTE: zsh module will load *.plugin.zsh files by default if they are located in the src=<folder>, so
    # supply the full folder path to the plugin in src=. To find the correct path, atm you must check the
    # plugins derivation until PR XXXX (file issue) is fixed
    plugins =
      [
        {
          name = "zhooks";
          src = "${pkgs.zhooks}/share/zsh/zhooks";
        }
        {
          name = "you-should-use";
          src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
        }
        # Allow zsh to be used in nix-shell
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ]

      # The iso doesn't use our overlays, so don't add custom packages
      #FIXME:move these to an optional custom plugins module and remove iso check
      ++ [
        {
          name = "zsh-term-title";
          src = "${pkgs.zsh-term-title}/share/zsh/zsh-term-title/";
        }
        {
          name = "cd-gitroot";
          src = "${pkgs.cd-gitroot}/share/zsh/cd-gitroot";
        }
        {
          name = "zsh-deep-autocd";
          src = "${pkgs.zsh-deep-autocd}/share/zsh/zsh-deep-autocd";
        }
        {
          name = "zsh-autols";
          src = "${pkgs.zsh-autols}/share/zsh/zsh-autols";
        }
      ]
      |> lib.optionals (config.hostSpec.hostName != "iso" && pkgs ? "zsh-term-title");

    # enable transient prompt
    initContent =
      transientPrompt
      |> lib.optionalString (
        config.programs.starship.enable && config.programs.starship.enableTransience
      );

    oh-my-zsh = {
      enable = true;
      # Standard OMZ plugins pre-installed to $ZSH/plugins/
      # Custom OMZ plugins are added to $ZSH_CUSTOM/plugins/
      # Enabling too many plugins will slowdown shell startup
      plugins = [
        "git"
        # NOTE: disabling sudo plugin because it is super annoying with esc/ctrl mapped to same key
        #"sudo" # press Esc twice to get the previous command prefixed with sudo https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
      ];
      extraConfig = ''
        # Display red dots whilst waiting for completion.
                COMPLETION_WAITING_DOTS="true"
      '';
    };

    shellAliases = import ./aliases.nix { inherit config; };
  };
}
