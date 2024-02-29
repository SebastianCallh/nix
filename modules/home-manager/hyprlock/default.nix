{ config, lib, ... }:
let
  cfg = config.hyprlock;
in
{
  options.hyprlock = with lib; {
    background = mkOption {
      type = types.path;
    };
  };

  config = {
    programs.hyprlock = {
      enable = true;
      general = {
        grace = 10;
        hide_cursor = true;
      };
  
      backgrounds = [
        {
           monitor = "eDP-1";
           color = "rgba(25, 20, 20, 1.0)";
        } #toString cfg.background; }
      ];
    };
  };
}
