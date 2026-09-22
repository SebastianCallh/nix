{ config, ... }:
let
  fullName = config.identity.fullName;
in
{
  flake.modules = {
    nixos.git = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.git ];
    };

    homeManager.git =
      { config, lib, ... }:
      let
        cfg = config.git;
      in
      {
        options.git = with lib; {
          userEmail = mkOption {
            type = types.str;
          };

          enableLazygit = mkOption {
            type = types.bool;
            default = false;
          };

          enableDelta = mkOption {
            type = types.bool;
            default = false;
          };

          deltaLight = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to use light mode for delta (should match your terminal theme).";
          };
        };

        config = {
          programs.git = {
            enable = true;
            signing.format = null;
            settings = {
              user = {
                name = fullName;
                email = cfg.userEmail;
              };
              init.defaultBranch = "main";
              push.autoSetupRemote = true;
            };
            lfs.enable = true;
          };

          programs.delta = {
            enable = cfg.enableDelta;
            enableGitIntegration = true;
            options = {
              syntax-theme = "base16";
              light = cfg.deltaLight;
            };
          };

          programs.lazygit = {
            enable = cfg.enableLazygit;
            settings = {
              git = {
                diffRenderers = [
                  {
                    colorArg = "always";
                    command = "delta --paging=never --hyperlinks --hyperlinks-file-link-format='lazygit-edit://{path}:{line}'";
                  }
                ];
              };
              gui = {
                returnImmediately = true;
              };
            };
          };
        };
      };
  };
}
