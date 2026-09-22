{ ... }:
{
  flake.modules.homeManager.waybar =
    { pkgs, config, lib, ... }:
    let
      inherit (lib) getExe';
      cfg = config.desktop;
    in
    {
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
              timeout = cfg.lockscreen.timeout;
              on-timeout = cfg.lockCommand;
            }
            {
              timeout = cfg.lockscreen.timeout + 60;
              on-timeout = "${dpmsCommand} off";
              on-resume = "${dpmsCommand} on";
            }
          ];
        };
      };
    };
}
