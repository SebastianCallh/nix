{ config, lib, ... }:
let
  cfg = config.hyprpaper;
in
{
  options.hyprpaper = with lib; {
    monitors = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption { type = types.str; };
          wallpaper = mkOption { type = types.path; };
        };
      });
      default = [];
    };
  };

  config = {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "off";
        splash = false;
        preload = map (m: toString m.wallpaper) cfg.monitors;
        wallpaper = map (m: "${m.name},${toString m.wallpaper}") cfg.monitors;
      };
    };
  };
}
