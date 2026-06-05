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

  outputs = { self, nixpkgs, nix-darwin, ... }@inputs: {
    nixosConfigurations.unidel = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/unidel/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.catppuccin.nixosModules.catppuccin
      ];
    };

    nixosConfigurations.violin = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/violin/configuration.nix
        inputs.home-manager.nixosModules.default
        # inputs.catppuccin.nixosModules.catppuccin
        inputs.stylix.nixosModules.stylix
      ];
    };

    nixosConfigurations.mad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/mad/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.stylix.nixosModules.stylix
      ];
    };

    darwinConfigurations.sigdis = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/sigdis/configuration.nix
        inputs.home-manager.darwinModules.default
      ];
    };
  };
}
