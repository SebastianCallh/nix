{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty";
    "$filemanager" = "dolphin";
    "$menu" = "wofi --show drun";

    exec-once = "hyprpaper & waybar";
    
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

    # see http://wiki.hyprland.org/Configuring/Window-Rules
    windowrulev2 = "nomaximizerequest, class:.*;";

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };
    
    bind = [
      "$mod, R, exec, $menu" 
      "$mod, T, exec, $terminal"
      "$mod, Q, exit"
      "$mod, P, pseudo," # dwindle
      "$mod, J, togglesplit," # dwindle

      # shift focus with arrow keys 
      "$mod, left, movefocus, l" 
      "$mod, right, movefocus, r" 
      "$mod, up, movefocus, u" 
      "$mod, down, movefocus, d" 

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
      "$mod SHIFT, 1, workspace, 1"
      "$mod SHIFT, 2, workspace, 2"
      "$mod SHIFT, 3, workspace, 3"
      "$mod SHIFT, 4, workspace, 4"
      "$mod SHIFT, 5, workspace, 5"
      "$mod SHIFT, 6, workspace, 6"
      "$mod SHIFT, 7, workspace, 7"
      "$mod SHIFT, 8, workspace, 8"
      "$mod SHIFT, 9, workspace, 9"
      "$mod SHIFT, 0, workspace, 10"
    ];
  }; 
}

