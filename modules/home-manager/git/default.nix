{config, lib, pkgs, ...}:
let
  cfg = config.git;
in
{
  options.git = with lib; {
    enable = mkEnableOption "enable";

    userName = mkOption {
      type = types.str;
    };

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
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
          init.defaultBranch = "main";
          push = {
            autoSetupRemote = true;
          };
          
        };
      };
      lfs.enable = true;
    };

    programs.delta = {
      enable = cfg.enableDelta;
      enableGitIntegration = true;
    };

    programs.lazygit = {
      enable = cfg.enableLazygit;
      settings = {
        git = {
          pagers = [
            {
              colorArg = "always";
              pager = "delta --dark --paging=never --hyperlinks --hyperlinks-file-link-format='lazygit-edit://{path}:{line}'";
            }
          ];
        };
      };
    };
  };
}

