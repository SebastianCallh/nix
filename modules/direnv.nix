{ config, ... }:
{
  flake.modules = {
    nixos.direnv = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.direnv ];
    };

    homeManager.direnv =
      { config, ... }:
      {
        programs.direnv = {
          enable = true;
          enableZshIntegration = config.programs.zsh.enable;
        };
      };
  };
}
