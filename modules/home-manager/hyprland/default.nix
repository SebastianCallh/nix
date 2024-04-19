{ config, lib, ... }:

let 
  cfg = config.hyprland;
  color = config.hyprland.colorScheme.palette;
in
{

  options.hyprland = with lib; {
    terminal = mkOption {
      type = types.str;
    };

    colorScheme = mkOption {
      description = ''
        The nix color palette to use.
      '';
    };
  };

  config = {
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      "$terminal" = cfg.terminal;
      "$menu" = "wofi --show drun";
  
      exec-once = "hyprpaper & waybar & mako & blueman-applet & nm-applet --indicator";
   
      monitor = ",preferred,auto,1";
      
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
        kb_options = "ctrl:nocaps";
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
        "$mod, Q, exit"
        "$mod, P, killactive"
        # "$mod, P, pseudo," # dwindle
        # "$mod, J, togglesplit," # dwindle
  
        # shift focus with arrow keys 
        "$mod, left, movefocus, l" 
        "$mod, right, movefocus, r" 
        "$mod, up, movefocus, u" 
        "$mod, down, movefocus, d" 
  
        # shift focus with vim bindings
        "$mod, H, movefocus, l" 
        "$mod, L, movefocus, r" 
        "$mod, K, movefocus, u" 
        "$mod, J, movefocus, d" 
  
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

