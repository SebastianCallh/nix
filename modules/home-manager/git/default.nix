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
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      extraConfig = {
        init.defaultBranch = "main";
        push = {
          autoSetupRemote = true;
        };
      };
    };

    programs.git.delta = {
      enable = cfg.enableDelta;
    };

    programs.lazygit = {
      enable = cfg.enableLazygit;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never --hyperlinks --hyperlinks-file-link-format='lazygit-edit://{path}:{line}'";
          };
        };
      };
    };

    home.packages = [
      pkgs.git-lfs
    ];
  };
}

