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

  config = let
    preloads = builtins.concatStringsSep "\n" (map
      (m: "preload = ${toString m.wallpaper}")
      cfg.monitors);

    wallpapers = builtins.concatStringsSep "\n" (map
      (m: "wallpaper = ${m.name},${toString m.wallpaper}")
      cfg.monitors);
  in {
    home.file.".config/hypr/hyprpaper.conf".text = ''
      ipc = off # don't tick and check IPC
      splash = false
      ${preloads}
      ${wallpapers}
    '';
  };
}
