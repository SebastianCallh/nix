{ config, ... }:
{
  flake.modules = {
    nixos.coding = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.coding ];
    };

    homeManager.coding =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          gnumake
          jq

          # these are needed to build many python dependencies
          stdenv.cc.cc.lib
          zlib
          expat
          glib
        ];

        programs.claude-code.enable = true;
        programs.gh.enable = true;
      };
  };
}
