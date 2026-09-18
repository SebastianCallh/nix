{ config, pkgs, lib, ... }: 
let
  cfg = config.desktop;
  lockCommand =
    if cfg.shell == "noctalia"
    then "${lib.getExe pkgs.noctalia} msg session lock"
    else "${pkgs.hyprlock}/bin/hyprlock";
in {
  imports = [
    ./styling.nix
    ./monitors.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprshutdown.nix
    ./hyprsunset.nix
    ./noctalia.nix
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

    shell = mkOption {
      type = types.enum [ "waybar" "noctalia" ];
      default = "waybar";
      description = ''
        Which desktop shell to run. "waybar" is the waybar/wofi/swaync/hypr*
        stack, "noctalia" replaces all of it with noctalia.
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
    
    hypridle = {
      timeout = cfg.lockscreen.timeout;
      lockCommand = lockCommand;
    };

    hyprpaper.monitors = map (m: { inherit (m) name wallpaper; }) cfg.monitors;
    
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
          pkgs.xdg-desktop-portal-hyprland
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
