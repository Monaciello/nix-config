{
  description = "EmergentMind's Nix-Config";
  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      introdus,
      nix-secrets,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      namespace = "emergentmind"; # namespace for our custom modules. Snowfall lib style

      introdusLib = introdus.lib.mkIntrodusLib {
        lib = nixpkgs.lib;
        secrets = nix-secrets;
      };
      customLib = nixpkgs.lib.extend (
        self: super: {
          custom =
            introdusLib
            # NOTE: This overrides introdusLib entries with local changes via
            # '//' in case I want to test something
            // (import ./lib {
              inherit (nixpkgs) lib;
            });
        }
      );

      secrets = nix-secrets.mkSecrets nixpkgs customLib;

      mkHost = host: isDarwin: {
        ${host} =
          let
            func = if isDarwin then inputs.nix-darwin.lib.darwinSystem else lib.nixosSystem;
            systemFunc = func;
            # Propagate lib.custom into hm
            # see: https://github.com/nix-community/home-manager/pull/3454
          in
          systemFunc {
            specialArgs = rec {
              inherit
                inputs
                outputs
                namespace
                secrets
                ;
              lib = customLib;
              inherit isDarwin;
            };
            modules = [
              ./hosts/${if isDarwin then "darwin" else "nixos"}/${host}
            ];
          };
      };
      mkHostConfigs =
        hosts: isDarwin: lib.foldl (acc: set: acc // set) { } (lib.map (host: mkHost host isDarwin) hosts);
      readHosts = folder: lib.attrNames (builtins.readDir ./hosts/${folder});
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        # Custom modifications/overrides to upstream packages
        overlays = (
          import ./overlays {
            inherit inputs lib secrets;
          }
        );
        # Build host configs
        nixosConfigurations = mkHostConfigs (readHosts "nixos") false;
        # darwinConfigurations = mkHostConfigs (readHosts "darwin") true;
      };
      systems = [
        "x86_64-linux"
      ];
      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              introdus.overlays.default
              self.overlays.default
            ];
          };
        in
        rec {
          # Expose custom packages
          _module.args.pkgs = pkgs;
          packages = lib.packagesFromDirectoryRecursive {
            callPackage = lib.callPackageWith pkgs;
            directory = ./pkgs;
          };
          # Pre-commit checks
          checks = import ./checks {
            inherit
              inputs
              pkgs
              system
              lib
              ;
          };
          # Nix formatter available through 'nix fmt' https://github.com/NixOS/nixfmt
          formatter = pkgs.nixfmt;
          # Custom shell for bootstrapping, nix-config dev, and secrets management
          devShells = import ./shell.nix {
            inherit
              checks
              inputs
              system
              pkgs
              lib
              ;
          };
        };
    };

  inputs = {
    #
    # ========= Official NixOS, Darwin, and HM Package Sources =========
    #
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # The next two are for pinning to stable vs unstable regardless of what the above is set to
    # This is particularly useful when an upcoming stable release is in beta because you can effectively
    # keep 'nixpkgs-stable' set to stable for critical packages while setting 'nixpkgs' to the beta branch to
    # get a jump start on deprecation changes.
    # See also 'stable-packages' and 'unstable-packages' overlays at 'overlays/default.nix"
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    # Modern nixos-hardware alternative
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    # nix-darwin = {
    #   url = "github:lnl7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs-darwin";
    # };

    #
    # ========= Utilities =========
    #
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets management. See ./docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Declarative vms using libvirt
    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # vim4LMFQR!
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
      #url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # Pre-commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #
    # ========= Ricing =========
    #
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      # FIXME(sddm): Pinned because of https://github.com/uiriansan/SilentSDDM/issues/55
      url = "github:uiriansan/SilentSDDM?rev=cfb0e3eb380cfc61e73ad4bce90e4dcbb9400291";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #
    # ========= Personal Repositories =========
    #
    # Private secrets repo.  See ./docs/secretsmgmt.md
    # Authenticate via ssh and use shallow clone
    nix-secrets = {
      url = "git+ssh://git@gitlab.com/emergentmind/nix-secrets.git?ref=main&shallow=1";
      inputs = { };
    };
    nix-assets = {
      url = "github:emergentmind/nix-assets";
    };
    introdus = {
      url = "git+ssh://git@codeberg.org/fidgetingbits/introdus?shallow=1&ref=aa";
    };
  };
}
