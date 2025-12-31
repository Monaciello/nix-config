# Development utilities I want across all systems
{
  lib,
  pkgs,
  ...
}:
{
  imports = lib.custom.scanPaths ./.;

  home.packages = lib.flatten [
    (lib.attrValues {
      inherit (pkgs)
        # Development
        delta # diffing
        act # github workflow runner
        gh # github cli
        gdb
        glab # gitlab cli
        yq-go # Parser for Yaml and Toml Files, that mirrors jq

        # nix
        nixpkgs-review

        # networking
        nmap

        # Diffing
        difftastic

        # serial debugging
        screen

        # Standard man pages for linux API
        man-pages
        man-pages-posix
        ;
      inherit (pkgs.unstable)
        devenv

        mob # mob programming tool
        ;
    })
  ];

  home.file.".editorconfig".text = ''
    root = true

    [*]
    end_of_line = lf
    insert_final_newline = true
    indent_style = space
    indent_size = 4

    [*.nix]
    indent_style = space
    indent_size = 2

    [*.lua]
    indent_style = space
    indent_size = 2

    [Makefile]
    indent_style = tab
  '';
}
