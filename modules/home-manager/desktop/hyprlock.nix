{ config, lib, ... }:
let
  cfg = config.hyprlock;
in
{
  options.hyprlock = with lib; {
    wallpaper = mkOption {
      type = types.path;
    };
  };

  config = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 10;
          hide_cursor = true;
        };
      };
    };
  };
}
