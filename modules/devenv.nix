{ config, ... }:
{
  flake.modules = {
    nixos.devenv = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.devenv ];
    };

    homeManager.devenv =
      { pkgs, lib, config, ... }:
      {
        home.packages = [ pkgs.devenv ];

        programs.zsh.initContent = lib.mkIf config.programs.zsh.enable ''
          eval "$(devenv hook zsh)"
        '';
      };
  };
}
