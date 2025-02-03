{ pkgs, config, lib, ... }:
let
  cfg = config.hyprland;
  color = config.styling.colorScheme.palette;
in
{
  options.hyprland = with lib; {
    terminal = mkOption {
      type = types.str;
      description = ''
        Executable for the terminal to use.
      '';
    };

    lockCommand = mkOption {
      type = types.str;
    };
  };

  config = {
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      "$terminal" = cfg.terminal;
      "$menu" = "${config.programs.wofi.package}/bin/wofi --show drun";
      "$locker" = cfg.lockCommand;
      "$sidebar" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t";
      "$printscreen" = "${pkgs.grimblast}/bin/grimblast copysave area";
      exec-once = "hyprpaper & waybar & swayidle -w & swaync & blueman-applet & nm-applet --indicator";
   
    monitor = map
      (m:
        let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          # position = "${toString m.x}x${toString m.y}";
          # position = "auto-up";
        in
          "${m.name},${if m.enabled then "${resolution},${m.position},${toString m.scale}" else "disable"}"
      )
      config.desktop.monitors;
      
      general = {
        border_size = 2;
        gaps_in = 8;
        gaps_out = 8;
        "col.active_border" = "rgba(${color.base0C}FF) rgba(${color.base05}FF) 45deg";
      };

      decoration = {
        rounding = 10;
        dim_inactive = true;
        dim_strength = 0.1;
      };

      input = { 
        kb_layout = "us,se";
        kb_options = "ctrl:nocaps,grp:alt_shift_toggle";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = 1;
        };
      };
  
      dwindle = { 
        pseudotile = true;
        preserve_split = true;
      };
   
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      
      bind = [
        "$mod, R, exec, $menu" 
        "$mod, T, exec, $terminal"
        "$mod, P, exec, $locker"
        "$mod, N, exec, $sidebar"
        "$mod, S, exec, $printscreen"
        "$mod, Q, exit"
        "$mod, W, killactive"
        # "$mod, P, pseudo," # dwindle
        # "$mod, J, togglesplit," # dwindle
  
        # shift focus with arrow keys 
        "$mod, left, movefocus, l" 
        "$mod, right, movefocus, r" 
        "$mod, up, movefocus, u" 
        "$mod, down, movefocus, d" 

         # shift focus with vim keys
        "$mod, H, movefocus, l" 
        "$mod, L, movefocus, r" 
        "$mod, K, movefocus, u" 
        "$mod, J, movefocus, d" 
  
        # move window with vim keys
        "$mod shift, left, movewindow, l" 
        "$mod shift, right, movewindow, r" 
        "$mod shift, up, movewindow, u" 
        "$mod shift, down, movewindow, d" 
  
        # switch workspace 
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
  
        # move to workspace 
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];
  
      # l -> do stuff even when locked
      # e -> repeats when key is held
      bindle = [
        # volume controls
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86MicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
  
        # screen brightness
        ",XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];
  
      bindl = [
        # media controls
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
    }; 
  };
}

