{ config, ... }:
let
  attach = {
    home-manager.sharedModules = [ config.flake.modules.homeManager.kitty ];
  };
in
{
  flake.modules = {
    nixos.kitty = attach;
    darwin.kitty = attach;

    homeManager.kitty =
      { config, lib, ... }:
      {
        options.kitty.font = with lib; mkOption {
          type = hm.types.fontType;
          default = "consolas";
        };

        config.programs.kitty = {
          enable = true;
          font = config.kitty.font;
        };
      };
  };
}
