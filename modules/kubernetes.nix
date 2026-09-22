{ config, ... }:
{
  flake.modules = {
    nixos.kubernetes = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.kubernetes ];
    };

    homeManager.kubernetes =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          kubectl
          kubernetes-helm
        ];

        programs.k9s.enable = true;
      };
  };
}
