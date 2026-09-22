{ config, ... }:
let
  username = config.identity.username;
in
{
  flake.modules = {
    nixos.docker = {
      users.users.${username}.extraGroups = [ "docker" ];

      virtualisation.docker = {
        enable = true;
        # rootless = {
        #   enable = true;
        #   setSocketVariable = true;
        # };
      };

      home-manager.sharedModules = [ config.flake.modules.homeManager.docker ];
    };

    homeManager.docker =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.lazydocker
          pkgs.docker-buildx
        ];

        xdg.configFile."lazydocker/config.yml".source = (pkgs.formats.yaml { }).generate "config" {
          commandTemplates = {
            dockerCompose = "docker compose";
          };

          gui = {
            returnImmediately = true;
          };
        };
      };
  };
}
