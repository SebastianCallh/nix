{ config, ... }:
{
  flake.modules = {
    nixos.syncthing = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.syncthing ];
    };

    homeManager.syncthing = {
      services.syncthing.enable = true;
    };
  };
}
