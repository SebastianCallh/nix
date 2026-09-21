{ pkgs, config, lib, ... }:
let
  cfg = config.hyprland;
  noctalia = config.desktop.shell == "noctalia";
  ipc = "${lib.getExe pkgs.noctalia} msg";
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

  config = lib.mkIf (config.desktop.compositor == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
    };

    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      "$terminal" = cfg.terminal;
      "$menu" =
        if noctalia
        then "${ipc} panel-toggle launcher"
        else "${config.programs.wofi.package}/bin/wofi --show drun -a";
      "$locker" = cfg.lockCommand;
      "$sidebar" =
        if noctalia
        then "${ipc} panel-toggle control-center"
        else "${pkgs.swaynotificationcenter}/bin/swaync-client -t";
      "$printscreen" =
        if noctalia
        then "${ipc} screenshot-region"
        else "${pkgs.grimblast}/bin/grimblast copysave area";
      "$powermenu" =
        if noctalia
        then "${ipc} panel-toggle session"
        else "hyprshutdown";

      # noctalia runs as a user unit and brings its own wallpaper, bar,
      # notifications and tray, so none of those need starting here.
      exec-once =
        lib.optionals (!noctalia) [
          "hyprpaper"
          "waybar"
          "swaync"
          "blueman-applet"
          "nm-applet --indicator"
        ]
        ++ [
          "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit"
        ];

    monitor = map
      (m:
        let
          resolution = "${m.resolution}@${toString m.refreshRate}";
        in
          "${m.name},${if m.enabled then "${resolution},${m.position},${toString m.scale}" else "disable"}"
      )
      config.desktop.monitors;

      general = {
        gaps_in = 2;
        gaps_out = 2;
      };

      decoration = {
        dim_inactive = true;
        dim_strength = 0.12;
      };

      animations = {
        enabled = false;
      };

      input = {
        kb_layout = "us,se";
        kb_options = "ctrl:nocaps";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = 1;
        };
      };

      dwindle = {
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # Prevent JetBrains tooltip/popup windows from stealing focus,
      # which causes an infinite re-render flickering loop.
      windowrule = [
        "no_initial_focus on, match:class ^(jetbrains-.*)$, match:title ^(win.*)$"
        "no_focus on, match:class ^(jetbrains-.*)$, match:title ^(win.*)$"
      ] ++ lib.optionals noctalia [
        "float on, match:class ^(dev\\.noctalia\\.Noctalia)$"
      ];

      bind = [
        "$mod, R, exec, $menu"
        "$mod, T, exec, $terminal"
        "$mod, P, exec, $locker"
        "$mod, N, exec, $sidebar"
        "$mod, S, exec, $printscreen"
        "$mod, Q, exec, $powermenu"
        "$mod, W, killactive"
        "$mod, space, exec, hyprctl switchxkblayout all next"
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
      ] ++ lib.optionals noctalia [
        "$mod, V, exec, ${ipc} panel-toggle clipboard"
        "$mod, comma, exec, ${ipc} settings-toggle"
        "ALT, Tab, exec, ${ipc} window-switcher"
      ];

      # l -> do stuff even when locked
      # e -> repeats when key is held
      bindle =
        if noctalia
        then [
          # volume controls, routed through noctalia so its OSD shows
          ",XF86AudioRaiseVolume, exec, ${ipc} volume-up"
          ",XF86AudioLowerVolume, exec, ${ipc} volume-down"
          ",XF86AudioMute, exec, ${ipc} volume-mute"
          ",XF86MicMute, exec, ${ipc} mic-mute"

          # screen brightness
          ",XF86MonBrightnessUp, exec, ${ipc} brightness-up"
          ",XF86MonBrightnessDown, exec, ${ipc} brightness-down"
        ]
        else [
          # volume controls
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86MicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

          # screen brightness
          ",XF86MonBrightnessUp, exec, brightnessctl s +5%"
          ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ];

      bindl =
        if noctalia
        then [
          # media controls
          ",XF86AudioPlay, exec, ${ipc} media toggle"
          ",XF86AudioNext, exec, ${ipc} media next"
          ",XF86AudioPrev, exec, ${ipc} media previous"
        ]
        else [
          # media controls
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPrev, exec, playerctl previous"
        ];
    };
  };
}
