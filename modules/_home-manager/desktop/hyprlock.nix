{ config, lib, ... }:
let
  cfg = config.hyprlock;
in
{
  options.hyprlock = {};

  config = {
    programs.hyprlock = {
      enable = config.desktop.shell == "waybar";
      settings = {
        general = {
          grace = 10;
          hide_cursor = true;
        };
      };
    };
  };
}
