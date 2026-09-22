{ config, ... }:
let
  fullName = config.identity.fullName;
in
{
  flake.modules = {
    nixos.jujutsu = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.jujutsu ];
    };

    homeManager.jujutsu =
      { config, lib, ... }:
      {
        options.jujutsu = with lib; {
          userEmail = mkOption {
            type = types.str;
          };
        };

        config = {
          programs.jujutsu = {
            enable = true;
            settings = {
              user = {
                name = fullName;
                email = config.jujutsu.userEmail;
              };
            };
          };
        };
      };
  };
}
