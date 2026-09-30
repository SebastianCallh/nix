# Only compositor-generic configuration lives here. Anything that talks to a
# desktop shell is contributed by that shell's own module, so a host picks its
# compositor and its shell independently and neither file branches on the other.
{ config, ... }:
{
  flake.modules = {

    nixos.niri = {
      # Bare executable name rather than a store path; see core.session.
      core.session = "niri-session";

      home-manager.sharedModules = [ config.flake.modules.homeManager.niri ];
    };

    homeManager.niri =
      { pkgs, config, lib, ... }:
      let
        c = config.lib.stylix.colors;

        # Hyprland takes "<width>x<height>" or "preferred" plus a separate
        # refresh rate; niri takes a single "<width>x<height>@<rate>" mode and
        # picks one itself when the node is absent.
        mode =
          m:
          lib.optionalAttrs (m.resolution != "preferred") {
            mode = "${m.resolution}@${toString m.refreshRate}";
          };

        # Hyprland accepts "auto", "auto-down" and friends; niri has no such
        # keyword and auto-places any output without a position node. Explicit
        # hyprland positions are written "<x>x<y>".
        position =
          m:
          let
            coords = lib.splitString "x" m.position;
          in
          lib.optionalAttrs (!lib.hasPrefix "auto" m.position && lib.length coords == 2) {
            position._props = {
              x = lib.toInt (lib.elemAt coords 0);
              y = lib.toInt (lib.elemAt coords 1);
            };
          };

        output = m: {
          output =
            { _args = [ m.name ]; }
            // (
              if m.enabled then { scale = builtins.fromJSON m.scale; } // mode m // position m else { off = { }; }
            );
        };

        # Niri's spawn takes an argv list, but every command this module has to
        # run arrives as a single string (terminal.command carries arguments, the
        # shell IPC calls are multi-word). spawn-sh takes the string as-is.
        sh = command: { spawn-sh = command; };
      in
      {
        wayland.windowManager.niri = {
          enable = true;

          settings = {
            # Lets niri draw its own focus ring around windows instead of behind
            # them, and removes the client-side titlebars that a tiling layout
            # has no use for.
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
            };

            layout = {
              gaps = 12;

              # Two new windows fill the screen exactly, so no sliver of a
              # neighbour sticks out at the edge. Mod+R cycles the other widths.
              default-column-width.proportion = 0.5;

              # A column too wide to share the screen with its neighbour is
              # centred, so neighbours show evenly on both sides rather than as
              # one lopsided slice. A lone column sits in the middle.
              center-focused-column = "on-overflow";
              always-center-single-column = { };

              # what Mod+R cycles through. Default presets stop at 2/3.
              preset-column-widths._children = [
                { proportion = 0.33333; }
                { proportion = 0.5; }
                { proportion = 0.66667; }
                { proportion = 1.0; }
              ];

              focus-ring = {
                width = 2;
                active-color = "#${c.base0D-hex}";
                inactive-color = "#${c.base02-hex}";
              };

              # There is no stylix target for niri, so the palette above is
              # wired up by hand. Keep the border off and let the focus ring do
              # the work, as niri's own default config recommends.
              border.off = { };
            };

            # Not cosmetic here. The strip sliding sideways is what separates
            # moving along a row of columns from jumping to another workspace,
            # which otherwise look the same. The slowdown keeps every animation
            # short enough to read as direction rather than wait through.
            animations.slowdown = 0.3;

            # Outputs, startup commands and window rules are all repeated
            # top-level nodes, so they share one ordered _children list. A
            # shell module appends its own entries to this list.
            _children =
              map output config.desktop.monitors
              ++ [
                {
                  spawn-at-startup._args = [
                    "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit"
                  ];
                }

                # Hyprland dims inactive windows; niri has no dim, so the
                # closest equivalent is to make them slightly transparent. Kept
                # faint, because a clearly see-through window reads as a glitch.
                {
                  window-rule._children = [
                    { match._props.is-active = false; }
                    { opacity = 0.95; }
                  ];
                }

                # Prevent JetBrains tooltip/popup windows from stealing focus,
                # which causes an infinite re-render flickering loop. Niri has
                # no counterpart to hyprland's no_focus, so only the initial
                # focus can be suppressed here.
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
              ];

            binds = {
              "Mod+T" = sh config.desktop.terminal;
              "Mod+P" = sh config.desktop.lockCommand;

              "Mod+W".close-window = { };
              "Mod+Space".switch-layout = "next";

              # Niri's own key for its cheatsheet, and the only place the real
              # keymap is visible now that this file and the shell module both
              # write into it.
              "Mod+Shift+Slash".show-hotkey-overlay = { };

              # Cycles the focused column width
              "Mod+R".switch-preset-column-width = { };

              # Finer width control, and a way to put the focused column in the
              # middle of the screen when on-overflow centring does not apply.
              "Mod+Minus".set-column-width = "-10%";
              "Mod+Equal".set-column-width = "+10%";
              "Mod+C".center-column = { };

              # Grows the column into whatever space is free on screen without
              # pushing its visible neighbours off, unlike Mod+F.
              "Mod+Ctrl+F".expand-column-to-available-width = { };

              # Shows a column's stacked windows as tabs at full height. Niri's
              # own key for this is Mod+W, which closes windows here.
              "Mod+E".toggle-column-tabbed-display = { };

              # Jump to either end of the strip.
              "Mod+Home".focus-column-first = { };
              "Mod+End".focus-column-last = { };

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

              # Stack windows into a column and pull them back out. Niri's own
              # Mod+Comma and Mod+Period are taken by the shell module, and one
              # pair of keys covers consume and expel in both directions.
              "Mod+BracketLeft".consume-or-expel-window-left = { };
              "Mod+BracketRight".consume-or-expel-window-right = { };

              # Maximize grows the column to the full width of the screen and
              # leaves the rest of the strip in place; fullscreen hides it.
              "Mod+F".maximize-column = { };
              "Mod+Shift+F".fullscreen-window = { };

              # Mod+V is the shell's clipboard, so floating takes the shifted
              # layout key. The second bind is the only way back to a floating
              # window once focus has moved to the tiling layer.
              "Mod+Shift+Space".toggle-window-floating = { };
              "Mod+Ctrl+Space".switch-focus-between-floating-and-tiling = { };

              # Zoomed-out view of every workspace. Niri's own key for this is
              # Mod+O, which stays unbound so the open program can have it.
              "Mod+Tab".toggle-overview = { };

              # Workspaces are stacked vertically, so these walk the stack
              # without having to know the index Mod+1 to Mod+0 would need.
              "Mod+U".focus-workspace-down = { };
              "Mod+I".focus-workspace-up = { };
              "Mod+Shift+U".move-column-to-workspace-down = { };
              "Mod+Shift+I".move-column-to-workspace-up = { };

              # Screens sit side by side, so left and right are the only
              # directions needed.
              "Mod+Ctrl+Left".focus-monitor-left = { };
              "Mod+Ctrl+Right".focus-monitor-right = { };
              "Mod+Ctrl+Shift+Left".move-workspace-to-monitor-left = { };
              "Mod+Ctrl+Shift+Right".move-workspace-to-monitor-right = { };
            }
            # switch to / move to workspace
            // lib.listToAttrs (
              lib.concatMap (
                i:
                let
                  key = if i == 10 then "0" else toString i;
                in
                [
                  (lib.nameValuePair "Mod+${key}" { focus-workspace = i; })
                  (lib.nameValuePair "Mod+Shift+${key}" { move-column-to-workspace = i; })
                ]
              ) (lib.range 1 10)
            );
          };
        };
      };
  };
}
