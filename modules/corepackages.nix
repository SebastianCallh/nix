{ config, ... }:
{
  flake.modules = {
    nixos.corepackages = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.corepackages ];
    };

    homeManager.corepackages =
      { pkgs, lib, ... }:
      {
        nixpkgs.config = {
          allowUnfree = true;
          allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "discord"
              "obsidian"
              "slack"
              "spotify"
            ];
        };

        home.packages = with pkgs; [
          # cli tools
          curl
          fastfetch
          nil
          ripgrep
          grimblast
          dconf # https://github.com/nix-community/home-manager/issues/3113
          tree
          file
          unzip
          killall
          bottom

          # graphical programs
          spotify
          obsidian
        ];

        services.udiskie = {
          enable = true;
          settings = {
            # workaround for
            # https://github.com/nix-community/home-manager/issues/632
            program_options = {
              # replace with your favorite file manager
              file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
            };
          };
        };
      };
  };
}
