{ pkgs, config, lib, ... }:
let
  cfg = config.niri;
  c = config.lib.stylix.colors;
  noctalia = config.desktop.shell == "noctalia";
  ipc = "${lib.getExe pkgs.noctalia} msg";

  # Hyprland takes "<width>x<height>" or "preferred" plus a separate refresh
  # rate; niri takes a single "<width>x<height>@<rate>" mode and picks one
  # itself when the node is absent.
  mode = m: lib.optionalAttrs (m.resolution != "preferred") {
    mode = "${m.resolution}@${toString m.refreshRate}";
  };

  # Hyprland accepts "auto", "auto-down" and friends; niri has no such
  # keyword and auto-places any output without a position node. Explicit
  # hyprland positions are written "<x>x<y>".
  position = m:
    let coords = lib.splitString "x" m.position;
    in lib.optionalAttrs (!lib.hasPrefix "auto" m.position && lib.length coords == 2) {
      position._props = {
        x = lib.toInt (lib.elemAt coords 0);
        y = lib.toInt (lib.elemAt coords 1);
      };
    };

  output = m: {
    output =
      { _args = [ m.name ]; }
      // (if m.enabled
          then { scale = builtins.fromJSON m.scale; } // mode m // position m
          else { off = { }; });
  };

  # Niri's spawn takes an argv list, but every command this module has to run
  # arrives as a single string (sh.command carries arguments, the noctalia IPC
  # calls are multi-word). spawn-sh takes the string as-is.
  sh = command: { spawn-sh = command; };
  locked = command: { _props.allow-when-locked = true; } // sh command;
in
{
  options.niri = with lib; {
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

  config = lib.mkIf (config.desktop.compositor == "niri") {
    wayland.windowManager.niri = {
      enable = true;

      settings = {
        # Lets niri draw its own focus ring around windows instead of behind
        # them, and removes the client-side titlebars that a tiling layout has
        # no use for.
        prefer-no-csd = { };

        hotkey-overlay.skip-at-startup = { };

        input = {
          keyboard.xkb = {
            layout = "us,se";
            options = "ctrl:nocaps";
          };

          touchpad = {
            tap = { };
            natural-scroll = { };
          };

          # Matches hyprland's follow_mouse = 1.
          focus-follows-mouse = { };
        };

        layout = {
          gaps = 2;

          focus-ring = {
            width = 2;
            active-color = "#${c.base0D-hex}";
            inactive-color = "#${c.base02-hex}";
          };

          # There is no stylix target for niri, so the palette above is wired
          # up by hand. Keep the border off and let the focus ring do the work,
          # as niri's own default config recommends.
          border.off = { };
        };

        animations.off = { };

        # Outputs, startup commands and window rules are all repeated
        # top-level nodes, so they share one ordered _children list.
        #
        # noctalia runs as a user unit and brings its own wallpaper, bar,
        # notifications, idle handling and tray, so none of those are started
        # here.
        _children =
          map output config.desktop.monitors
          ++ lib.optionals (!noctalia) [
            { spawn-at-startup._args = [ "hyprpaper" ]; }
            { spawn-at-startup._args = [ "waybar" ]; }
            { spawn-at-startup._args = [ "swaync" ]; }
            { spawn-at-startup._args = [ "blueman-applet" ]; }
            { spawn-at-startup._args = [ "nm-applet" "--indicator" ]; }
          ]
          ++ [
            {
              spawn-at-startup._args = [
                "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit"
              ];
            }

            # Hyprland dims inactive windows; niri has no dim, so the closest
            # equivalent is to make them slightly transparent.
            {
              window-rule._children = [
                { match._props.is-active = false; }
                { opacity = 0.88; }
              ];
            }

            # Prevent JetBrains tooltip/popup windows from stealing focus,
            # which causes an infinite re-render flickering loop. Niri has no
            # counterpart to hyprland's no_focus, so only the initial focus
            # can be suppressed here.
            {
              window-rule._children = [
                {
                  match._props = {
                    app-id = "^jetbrains-.*$";
                    title = "^win.*$";
                  };
                }
                { open-focused = false; }
              ];
            }
          ]
          ++ lib.optionals noctalia [
            {
              window-rule._children = [
                { match._props.app-id = "^dev\\.noctalia\\.Noctalia$"; }
                { open-floating = true; }
              ];
            }
          ];

        binds = {
          "Mod+R" = sh (if noctalia
                        then "${ipc} panel-toggle launcher"
                        else "${config.programs.wofi.package}/bin/wofi --show drun -a");
          "Mod+T" = sh cfg.terminal;
          "Mod+P" = sh cfg.lockCommand;
          "Mod+N" = sh (if noctalia
                        then "${ipc} panel-toggle control-center"
                        else "${pkgs.swaynotificationcenter}/bin/swaync-client -t");
          "Mod+S" = sh (if noctalia
                        then "${ipc} screenshot-region"
                        else "${pkgs.grimblast}/bin/grimblast copysave area");
          "Mod+Q" = sh (if noctalia
                        then "${ipc} panel-toggle session"
                        else "hyprshutdown");

          "Mod+W".close-window = { };
          "Mod+Space".switch-layout = "next";

          # shift focus with arrow keys
          "Mod+Left".focus-column-left = { };
          "Mod+Right".focus-column-right = { };
          "Mod+Up".focus-window-up = { };
          "Mod+Down".focus-window-down = { };

          # shift focus with vim keys
          "Mod+H".focus-column-left = { };
          "Mod+L".focus-column-right = { };
          "Mod+K".focus-window-up = { };
          "Mod+J".focus-window-down = { };

          # move window with arrow keys
          "Mod+Shift+Left".move-column-left = { };
          "Mod+Shift+Right".move-column-right = { };
          "Mod+Shift+Up".move-window-up = { };
          "Mod+Shift+Down".move-window-down = { };

          # volume controls, routed through noctalia so its OSD shows
          "XF86AudioRaiseVolume" = locked (if noctalia
            then "${ipc} volume-up"
            else "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+");
          "XF86AudioLowerVolume" = locked (if noctalia
            then "${ipc} volume-down"
            else "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-");
          "XF86AudioMute" = locked (if noctalia
            then "${ipc} volume-mute"
            else "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle");
          "XF86AudioMicMute" = locked (if noctalia
            then "${ipc} mic-mute"
            else "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle");

          # screen brightness
          "XF86MonBrightnessUp" = locked (if noctalia
            then "${ipc} brightness-up"
            else "brightnessctl s +5%");
          "XF86MonBrightnessDown" = locked (if noctalia
            then "${ipc} brightness-down"
            else "brightnessctl s 5%-");

          # media controls
          "XF86AudioPlay" = locked (if noctalia
            then "${ipc} media toggle"
            else "playerctl play-pause");
          "XF86AudioNext" = locked (if noctalia
            then "${ipc} media next"
            else "playerctl next");
          "XF86AudioPrev" = locked (if noctalia
            then "${ipc} media previous"
            else "playerctl previous");
        }
        # switch to / move to workspace
        // lib.listToAttrs (lib.concatMap
          (i:
            let
              key = if i == 10 then "0" else toString i;
            in [
              (lib.nameValuePair "Mod+${key}" { focus-workspace = i; })
              (lib.nameValuePair "Mod+Shift+${key}" { move-column-to-workspace = i; })
            ])
          (lib.range 1 10))
        // lib.optionalAttrs noctalia {
          "Mod+V" = sh "${ipc} panel-toggle clipboard";
          "Mod+Comma" = sh "${ipc} settings-toggle";
          "Alt+Tab" = sh "${ipc} window-switcher";
        };
      };
    };
  };
}
