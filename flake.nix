{
  description = "Sebastian Callh's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Pinned to the last revision where google-cloud-sdk's bundled python3.14
    # builds; 570.0.0 in current unstable fails auto-patchelf (libtcl9.0.so /
    # libpython3.14.so.1.0). Used only for gcloud in hosts/mad/home.nix.
    nixpkgs-gcloud.url = "github:nixos/nixpkgs/4100e830e085863741bc69b156ec4ccd53ab5be0";
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      # Hosts differ only in system, entry point, and which theming module they
      # pull in; everything else is identical boilerplate.
      nixosHost =
        { system, configuration, extraModules ? [ ] }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            configuration
            inputs.home-manager.nixosModules.default
          ] ++ extraModules;
        };

      darwinHost =
        { system, configuration, extraModules ? [ ] }:
        inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            configuration
            inputs.home-manager.darwinModules.default
          ] ++ extraModules;
        };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      # config.flake.modules is the trunk every aspect module under ./modules
      # contributes to, and what hosts below compose themselves from.
      { config, ... }:
      {
      imports = [
        # Provides flake.modules.<class>.<aspect>, the shared trunk that
        # aspect modules contribute to and hosts pick from.
        inputs.flake-parts.flakeModules.modules
        # Every .nix under ./modules is a flake-parts module, auto-imported.
        # Paths containing /_ are skipped: modules/_nixos and
        # modules/_home-manager still hold class modules that hosts import by
        # hand, and are migrated out of there aspect by aspect.
        (inputs.import-tree ./modules)
      ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      flake = {
        nixosConfigurations = {
          unidel = nixosHost {
            system = "x86_64-linux";
            configuration = ./hosts/unidel/configuration.nix;
            extraModules = [ inputs.catppuccin.nixosModules.catppuccin ];
          };

          violin = nixosHost {
            system = "x86_64-linux";
            configuration = ./hosts/violin/configuration.nix;
            extraModules = [ inputs.stylix.nixosModules.stylix ];
          };

          mad = nixosHost {
            system = "x86_64-linux";
            configuration = ./hosts/mad/configuration.nix;
            extraModules = [
              inputs.stylix.nixosModules.stylix
            ]
            # The whole compositor-and-shell decision, two words. Order
            # matters: the compositor contributes its niri nodes before the
            # shell appends its own.
            ++ (with config.flake.modules.nixos; [
              niri
              noctalia
            ]);
          };
        };

        darwinConfigurations.sigdis = darwinHost {
          system = "aarch64-darwin";
          configuration = ./hosts/sigdis/configuration.nix;
        };
      };
      }
    );
}
