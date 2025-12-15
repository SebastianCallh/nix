{ pkgs, config, lib, ... }:
let 
inherit (lib) getExe';
cfg = config.swayidle;
in
{
  options.swayidle = with lib; {
    timeout = mkOption {
      type = types.int;
    };

    lockCommand = mkOption {
      type = types.str;
    };
  };

  config = {
    services.swayidle = 
    {
      enable = true;
      timeouts =
        let
          dpmsCommand = "${getExe' pkgs.hyprland "hyprctl"} dispatch dpms";
        in
        [
          {
            timeout = cfg.timeout;
            command = cfg.lockCommand;
          }
          {
            timeout = cfg.timeout + 60;
            command = "${dpmsCommand} off";
            resumeCommand = "${dpmsCommand} on";
          }
        ];

      events = {
        "before-sleep" = cfg.lockCommand;
        "lock" = cfg.lockCommand;
      };
    };
  };
}
