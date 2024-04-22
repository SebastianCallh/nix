{ config, lib, ... }: 
let 
cfg = config.desktop;
lockCommand = "${config.programs.swaylock.package}/bin/swaylock -f";
in {
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./swaylock.nix
    ./swayidle.nix
    ./wofi.nix
    ./waybar
  ];

  options.desktop = with lib; {
    background = mkOption {
      type = types.path;
    };

    monitor = mkOption {
      type = types.str;
    };

    colorScheme = mkOption {
      description = ''
        The Nix color palette to use.
      '';
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
      background = mkOption {
        type = types.path;
      };
    
      timeout = mkOption {
        type = types.int;
      };
    };
  };

  config = {  
    hyprland.colorScheme = cfg.colorScheme;
    hyprland.terminal = cfg.terminal;
    hyprland.lockCommand = lockCommand;
    
    hyprpaper.background = cfg.background;
    hyprpaper.monitor = cfg.monitor;
    
    swaylock.background = cfg.lockscreen.background;
    swayidle.timeout = cfg.lockscreen.timeout;
    swayidle.lockCommand = lockCommand;

    wofi.font = cfg.wofi.font;
  };
}
