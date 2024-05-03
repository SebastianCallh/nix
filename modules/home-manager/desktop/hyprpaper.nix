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

  config = let
    preloads = builtins.concatStringsSep "\n" (map
      (m: "preload = ${toString m.wallpaper}")
      config.desktop.monitors);
      
    wallpapers = builtins.concatStringsSep "\n" (map
      (m: "wallpaper = ${m.name},${toString m.wallpaper}")
      config.desktop.monitors);
  in {
    home.file.".config/hypr/hyprpaper.conf".text = ''
      ipc = off # don't tick and check IPC
      splash = false
      ${preloads}
      ${wallpapers}
    '';
  };
}
