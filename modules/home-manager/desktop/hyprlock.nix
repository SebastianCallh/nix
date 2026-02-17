{ config, lib, ... }:
let
  cfg = config.hyprlock;
in
{
  options.hyprlock = {};

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
