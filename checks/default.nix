{
  inputs,
  system,
  pkgs,
  lib,
  formatter,
  ...
}:
let
  introdusLib = inputs.introdus.lib.mkIntrodusLib { inherit lib; };
in
{
  pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
    src = ../.;
    default_stages = [ "pre-commit" ];
    # NOTE: Hooks are run in alphabetical order
    hooks = lib.recursiveUpdate (introdusLib.checks.mkPreCommitHooks pkgs formatter) {
      # ========== General ==========
      check-added-large-files = {
        enable = true;
        excludes = [
          "\\.png"
          "\\.jpg"
        ];
      };

      forbid-submodules = {
        enable = true;
        name = "forbid submodules";
        description = "forbids any submodules in the repository";
        language = "fail";
        entry = "submodules are not allowed in this repository:";
        types = [ "directory" ];
      };

      destroyed-symlinks = {
        enable = true;
        name = "destroyed-symlinks";
        description = "detects symlinks which are changed to regular files with a content of a path which that symlink was pointing to.";
        package = inputs.pre-commit-hooks.checks.${system}.pre-commit-hooks;
        entry = "${inputs.pre-commit-hooks.checks.${system}.pre-commit-hooks}/bin/destroyed-symlinks";
        types = [ "symlink" ];
      };

      # ========== python ==========
      ruff.enable = true;
    };
  };
}
