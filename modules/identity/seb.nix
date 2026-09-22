{ config, lib, ... }:
let
  username = "seb";
  fullName = "Sebastian Callh";
  homeDirectory = "/home/${username}";
in
{
  options.identity = with lib; {
    username = mkOption { type = types.str; };
    fullName = mkOption { type = types.str; };
    homeDirectory = mkOption { type = types.str; };
  };

  config = {
    identity = {
      inherit username fullName homeDirectory;
    };

    flake.modules = {
      nixos.seb =
        { pkgs, ... }:
        {
          users.users.${username} = {
            isNormalUser = true;
            initialPassword = "12345";
            extraGroups = [
              "networkmanager"
              "wheel"
              "plugdev"
              "input"
            ];
            shell = pkgs.zsh;
          };

          home-manager.users.${username} = config.flake.modules.homeManager.seb;
        };

      homeManager.seb = {
        home = {
          inherit username homeDirectory;
        };
      };
    };
  };
}
