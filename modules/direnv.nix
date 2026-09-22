{ config, ... }:
let
  attach = {
    home-manager.sharedModules = [ config.flake.modules.homeManager.direnv ];
  };
in
{
  flake.modules = {
    nixos.direnv = attach;
    darwin.direnv = attach;

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
