{ lib, pkgs, ... }:
let
  scripts = {
    # FIXME: I currently get the following warnings:
    # svn: warning: cannot set LC_CTYPE locale
    # svn: warning: environment variable LANG is en_US.UTF-8
    # svn: warning: please check that your locale name is correct
    copy-github-subfolder = pkgs.writeShellApplication {
      name = "copy-github-subfolder";
      runtimeInputs = [ pkgs.subversion ];
      text = lib.readFile ./copy-github-subfolder.sh;
    };
    linktree = pkgs.writeShellApplication {
      name = "linktree";
      runtimeInputs = [ ];
      text = lib.readFile ./linktree.sh;
    };
  };
in
{
  home.packages = lib.attrValues { inherit (scripts) copy-github-subfolder linktree; };
}
