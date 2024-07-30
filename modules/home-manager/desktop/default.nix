{ config, lib, ... }: 
let
  cfg = config.desktop;
  lockCommand = "${config.programs.swaylock.package}/bin/swaylock -f";
in {
  imports = [
    ./styling.nix
    ./monitors.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./swaylock.nix
    ./swayidle.nix
    ./swaync.nix
    ./wofi.nix
    ./waybar
  ];

  options.desktop = with lib; {
    theme = mkOption {
      type = types.enum [ "light" "dark" ];  
    };

    terminal = mkOption {
      type = types.str;
      description = ''
        Executable for the terminal to use.
      '';
    };

    wofi = {
      font = mkOption {
        type = hm.types.fontType;
        default = {
          name = "consolas";
          size = 10;
        };
      };
    };      
  
    lockscreen = {
      wallpaper = mkOption {
        type = types.path;
      };
    
      timeout = mkOption {
        type = types.int;
      };
    };
  };

  config = {  
    hyprland = {
      terminal = cfg.terminal;
      lockCommand = lockCommand;
    };
    
    swayidle = {
      timeout = cfg.lockscreen.timeout;
      lockCommand = lockCommand;
    };
    
    styling.theme = cfg.theme;
    swaylock.wallpaper = cfg.lockscreen.wallpaper;
    wofi = {
      font = cfg.wofi.font;
      theme = cfg.theme;
    };
  };
}
