{config, lib, pkgs, ...}:
let
  cfg = config.jujutsu;
in
{
  options.jujutsu = with lib; {
    enable = mkEnableOption "enable";

    userName = mkOption {
      type = types.str;
    };

    userEmail = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
      };
    };
  };
}
