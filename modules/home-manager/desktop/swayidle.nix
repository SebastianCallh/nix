{ config, lib, ... }:
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
          dpmsCommand = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms";
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

      events = [
        {
          event = "before-sleep";
          command = cfg.lockCommand;
        }
        {
          event = "lock";
          command = cfg.lockCommand;
        }
      ];
    };
  };
}
