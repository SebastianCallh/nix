{ config, lib, ... }:
let 
  cfg = config.swaylock;
  color = config.styling.colorScheme.palette;
in
{
  options.swaylock = with lib; {
    wallpaper = mkOption {
      type = types.path;
    };
  };

  config = {
    programs.swaylock = {
      enable = true;
      settings = {
        image = toString cfg.wallpaper;
        font-size = 28;
        text-color = color.base05;
        text-clear-color = color.base05;
        text-wrong-color = color.base05;
        text-ver-color = color.base05;

        indicator-idle-visible = false;
        indicator-radius = 80;
        indicator-thickness = 10;

        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        
        key-hl-color = color.base0C;
        bs-hl-color = color.base09;

        ring-color = color.base05;
        ring-clear-color = color.base09;
        ring-wrong-color = color.base08;
        ring-ver-color = color.base0F;
        line-color = "00000000";

        show-failed-attempts = false; 
      };
    };
  };
}
