#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:

let
  # Adds my custom packages
  # FIXME: Add per-system packages
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final;
      directory = ../pkgs/common;
    });

  linuxModifications =
    final: prev:
    if prev.stdenv.isLinux then
      prev.lib.packagesFromDirectoryRecursive {
        # We pass self so that we can do some relative path computation for binary
        # blobs not tracked in our repo config
        callPackage = prev.lib.callPackageWith final;
        directory = ../pkgs/nixos;
      }
      // {
        linuxPackages_6_18 = prev.linuxPackages_6_18.extend (
          _lfinal: lprev: {
            xpadneo = lprev.xpadneo.overrideAttrs (old: {
              patches = (old.patches or [ ]) ++ [
                (prev.fetchpatch {
                  url = "https://github.com/orderedstereographic/xpadneo/commit/233e1768fff838b70b9e942c4a5eee60e57c54d4.patch";
                  hash = "sha256-HL+SdL9kv3gBOdtsSyh49fwYgMCTyNkrFrT+Ig0ns7E=";
                  stripLen = 2;
                })
              ];
            });
          }
        );
      }
    else
      { };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (previousAttrs: let ... in {
    # ...
    # });
  };

  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;

      #      overlays = [
      #     ];
    };
  };

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      overlays = [
        #        (unstable_final: unstable_prev: {
        #          mesa = unstable_prev.mesa.overrideAttrs (
        #            previousAttrs:
        #            let
        #              version = "25.2.2";
        #              hashes = {
        #                "25.2.2" = "sha256-9w/E5frSvCtPBI58ClXZyGyF59M+yVS4qi4khpfUZwk=";
        #                "25.1.6" = "sha256-SHYYezt2ez9awvIATEC6wVMZMuJUsOYXxlugs1Q6q7U=";
        #                "25.1.5" = "sha256-AZAd1/wiz8d0lXpim9obp6/K7ySP12rGFe8jZrc9Gl0=";
        #                "25.1.4" = "sha256-DA6fE+Ns91z146KbGlQldqkJlvGAxhzNdcmdIO0lHK8=";
        #                "25.1.3" = "sha256-BFncfkbpjVYO+7hYh5Ui6RACLq7/m6b8eIJ5B5lhq5Y=";
        #                "25.1.2" = "sha256-oE1QZyCBFdWCFq5T+Unf0GYpvCssVNOEQtPQgPbatQQ=";
        #              };
        #            in
        #            rec {
        #              inherit version;
        #              src = prev.fetchFromGitLab {
        #                domain = "gitlab.freedesktop.org";
        #                owner = "mesa";
        #                repo = "mesa";
        #                rev = "mesa-${version}";
        #                sha256 = if hashes ? ${version} then hashes.${version} else "";
        #              };
        #            }
        #          );
        #        })
      ];
    };
  };

in
{
  default =
    final: prev:

    (additions final prev)
    // (modifications final prev)
    // (linuxModifications final prev)
    // (stable-packages final prev)
    // (unstable-packages final prev);
}
