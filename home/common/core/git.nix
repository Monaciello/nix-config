# git is core no matter what but additional settings may could be added made in optional/foo   eg: development.nix
{
  pkgs,
  osConfig,
  ...
}:
{
  # All users get git no matterwhat but additional settings may be added by eg: development.nix
  home.packages = [
    pkgs.delta # git diff tool
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    settings = {
      core.pager = "delta";
      delta = {
        enable = true;
        features = [
          "side-by-side"
          "line-numbers"
          "hyperlinks"
          "line-numbers"
          "commit-decoration"
        ];
      };
      alias.edit = "!$EDITOR $(git status --porcelain | awk '{print $2}')";
    };
  };

  home.sessionVariables.GIT_EDITOR = osConfig.hostSpec.defaultEditor;
}
