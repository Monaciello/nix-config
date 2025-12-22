# Shell for bootstrapping flake-enabled nix and other tooling
{
  pkgs,
  checks,
  lib,
  ...
}:
{
  default = pkgs.mkShell {
    # Nix utility settings
    NIX_CONFIG = "extra-experimental-features = nix-command flakes pipe-operators";
    NIXPKGS_ALLOW_BROKEN = "1";

    # Bootstrap script settings
    BOOTSTRAP_USER = "aa";
    BOOTSTRAP_SSH_PORT = "10022";
    BOOTSTRAP_SSH_KEY = "~/.ssh/id_yubikey";
    NIX_SECRETS_DIR = "~/src/nix/nix-secrets";

    buildInputs = checks.pre-commit-check.enabledPackages;
    nativeBuildInputs =
      # FIXME: Some of these can go away because of the helpers.sh moving and
      # becoming self-contained?
      lib.attrValues {
        inherit (pkgs)
          home-manager
          git
          just
          pre-commit
          sops
          deadnix
          statix
          git-crypt # encrypt secrets in git not suited for sops
          attic-client # for attic backup
          nh # fancier nix building
          yq-go # jq for yaml, used for build scripts
          flyctl # for fly.io
          bats # for testing
          age # bootstrap script
          ssh-to-age # bootstrap script
          gum # shell script ricing
          bootstrap-nixos # introdus script for bootstrapping new hosts
          ;
      }
      ++ [
        # New enough to get memory management improvements
        pkgs.unstable.nixVersions.git
      ];
  };
}
