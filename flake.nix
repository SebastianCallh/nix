{
  description = "Sebastian Callh's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

 };

  outputs = { self, nixpkgs, nix-darwin, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.unidel = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/unidel/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      # darwinConfigurations."Sebastians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      darwinConfigurations.sigdis = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/sigdis/configuration.nix
          inputs.home-manager.darwinModules.default
        ];
      };
    };
}
