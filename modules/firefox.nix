{ config, ... }:
{
  flake.modules = {
    nixos.firefox = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.firefox ];
    };

    homeManager.firefox = {
      home.sessionVariables = {
        BROWSER = "firefox";
      };

      programs.firefox = {
        enable = true;
        configPath = ".mozilla/firefox";
        profiles = {
          seb = {
            id = 0;
            name = "seb";
          };
        };
      };
    };
  };
}
