{ config, lib, ... }:
let
cfg = config.hyprpaper;
in
{
  options.hyprpaper = with lib; {
    background = mkOption {
      type = types.path;
    };

    monitor = mkOption {
      type = types.str;
    };
  };

  config = {
    home.file.".config/hypr/hyprpaper.conf".text = ''
      preload = ${toString cfg.background}
      wallpaper = ${cfg.monitor},${toString cfg.background}
      ipc = off # don't tick and check IPC
      splash = false
    '';
  };
}
