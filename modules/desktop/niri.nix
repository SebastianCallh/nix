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
        # run arrives as a single string (sh.command carries arguments, the
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

              # There is no stylix target for niri, so the palette above is
              # wired up by hand. Keep the border off and let the focus ring do
              # the work, as niri's own default config recommends.
              border.off = { };
            };

            animations.off = { };

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
                # closest equivalent is to make them slightly transparent.
                {
                  window-rule._children = [
                    { match._props.is-active = false; }
                    { opacity = 0.88; }
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
