{ config, pkgs, lib, ... }: 
let
  cfg = config.desktop;
  lockCommand = "${config.programs.swaylock.package}/bin/swaylock -f";
in {
  imports = [
    ./styling.nix
    ./monitors.nix
    ./hyprland.nix
    ./swaylock.nix
    ./swayidle.nix
    ./swaync.nix
    ./wofi.nix
    ./waybar
  ];

  options.desktop = with lib; {
    terminal = mkOption {
      type = types.str;
      description = ''
        Executable for the terminal to use.
      '';
    };

    theme = mkOption {
      type = types.str;
      description = ''
        Theme to apply to the system.
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
    styling = {
      theme = cfg.theme;
    };

    hyprland = {
      terminal = cfg.terminal;
      lockCommand = lockCommand;
    };
    
    swayidle = {
      timeout = cfg.lockscreen.timeout;
      lockCommand = lockCommand;
    };
    
    swaylock.wallpaper = cfg.lockscreen.wallpaper;

    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        # config.commons.default = "xdg-desktop-portal-hyprland";
        config.common = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
          default = "*";
        };
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      # mime = {
      #   enable = true;
      #   defaultApplications = {
      #     "text/markdown" = [editor];
      #   };
      # };
    };

  };
}
