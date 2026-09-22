{ pkgs, config, lib, ... }:
let
  inherit (lib) getExe';
  cfg = config.hypridle;
in
{
  options.hypridle = with lib; {
    timeout = mkOption {
      type = types.int;
    };

    lockCommand = mkOption {
      type = types.str;
    };
  };

  config = {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = cfg.lockCommand;
          lock_cmd = cfg.lockCommand;
        };

        listener = let
          dpmsCommand = "${getExe' pkgs.hyprland "hyprctl"} dispatch dpms";
        in [
          {
            timeout = cfg.timeout;
            on-timeout = cfg.lockCommand;
          }
          {
            timeout = cfg.timeout + 60;
            on-timeout = "${dpmsCommand} off";
            on-resume = "${dpmsCommand} on";
          }
        ];
      };
    };
  };
}
