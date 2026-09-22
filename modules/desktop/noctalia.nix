# The noctalia desktop shell, both halves.
#
# noctalia replaces the whole waybar/wofi/swaync/hypr* stack: it draws the
# wallpaper, bar, notifications, OSD, lockscreen and idle handling itself, so a
# host importing this module starts none of those.
{ config, ... }:
{
  flake.modules = {

    nixos.noctalia = {
      # Previously a comment in hosts/mad/configuration.nix explaining why two
      # unrelated-looking services were enabled. noctalia reads the battery
      # through upower and the power profile through power-profiles-daemon;
      # without these its battery widget and the control center power shortcuts
      # stay empty.
      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;

      home-manager.sharedModules = [ config.flake.modules.homeManager.noctalia ];
    };

    homeManager.noctalia =
      { pkgs, config, lib, ... }:
      let
        ipc = "${lib.getExe pkgs.noctalia} msg";
        locked = command: {
          _props.allow-when-locked = true;
          spawn-sh = command;
        };
      in
      {
        config = lib.mkMerge [
          {
            # The compositor binds this; noctalia owns the lockscreen.
            desktop.lockCommand = "${ipc} session lock";

            # The stylix hyprland target turns hyprpaper on whenever
            # stylix.image is set; noctalia draws the wallpaper itself.
            stylix.targets.hyprland.hyprpaper.enable = false;

            # Stylix leaves polarity at "either" unless told otherwise, and its
            # noctalia target only emits a dark palette variant while picking
            # light mode for anything but an explicit "dark".
            stylix.polarity = if config.styling.isDark then "dark" else "light";

            # Theme, font family, wallpaper path and surface opacities all come
            # from the stylix noctalia target, so they are deliberately absent.
            programs.noctalia = {
              enable = true;
              systemd.enable = true;

              settings = {
                shell = {
                  polkit_agent = true;
                  # Without this, apps started from the launcher die whenever
                  # the noctalia user unit restarts.
                  launch_apps_as_systemd_services = true;
                  clipboard_enabled = true;
                  keyboard_layout.custom_labels = {
                    "English (US)" = "en";
                    "Swedish" = "se";
                  };
                };

                bar.default = {
                  position = "bottom";
                  thickness = 30;
                  margin_ends = 0;
                  radius = 0;
                  concave_edge_corners = false;
                  capsule_radius = 0;

                  start = [ "workspaces" ];
                  center = [ ];
                  end = [
                    "tray"
                    "ram"
                    "cpu"
                    "keyboard_layout"
                    "battery"
                    "clock"
                    "control-center"
                  ];
                };

                widget = {
                  cpu = {
                    type = "sysmon";
                    stat = "cpu_usage";
                  };

                  ram = {
                    type = "sysmon";
                    stat = "ram_used";
                  };

                  clock = {
                    format = "{:%H:%M}";
                    tooltip_format = "{:%A, %d %B %Y}";
                  };

                  battery = {
                    device = "BAT0";
                    label_content = "percent";
                  };

                  keyboard_layout = {
                    display = "short";
                  };
                };

                osd.position = "bottom_center";

                lockscreen = {
                  enabled = true;
                  lock_before_suspend = true;
                };

                idle.behavior = {
                  lock = {
                    timeout = config.desktop.lockscreen.timeout;
                    action = "lock";
                    enabled = true;
                  };

                  "screen-off" = {
                    timeout = config.desktop.lockscreen.timeout + 60;
                    action = "screen_off";
                    enabled = true;
                  };
                };

                nightlight = {
                  enabled = true;
                  temperature_day = 6500;
                  temperature_night = 4500;
                };

                wallpaper.enabled = true;
              };
            };
          }

          # Everything a shell wants from the compositor has to be expressed in
          # that compositor's own option tree, so each compositor noctalia
          # supports gets its own guarded block. niri is the only one so far.
          (lib.mkIf config.wayland.windowManager.niri.enable {
            wayland.windowManager.niri.settings = {
              binds = {
                "Mod+R".spawn-sh = "${ipc} panel-toggle launcher";
                "Mod+N".spawn-sh = "${ipc} panel-toggle control-center";
                "Mod+S".spawn-sh = "${ipc} screenshot-region";
                "Mod+Q".spawn-sh = "${ipc} panel-toggle session";
                "Mod+V".spawn-sh = "${ipc} panel-toggle clipboard";
                "Mod+Comma".spawn-sh = "${ipc} settings-toggle";
                "Alt+Tab".spawn-sh = "${ipc} window-switcher";

                # volume controls, routed through noctalia so its OSD shows
                "XF86AudioRaiseVolume" = locked "${ipc} volume-up";
                "XF86AudioLowerVolume" = locked "${ipc} volume-down";
                "XF86AudioMute" = locked "${ipc} volume-mute";
                "XF86AudioMicMute" = locked "${ipc} mic-mute";

                # screen brightness
                "XF86MonBrightnessUp" = locked "${ipc} brightness-up";
                "XF86MonBrightnessDown" = locked "${ipc} brightness-down";

                # media controls
                "XF86AudioPlay" = locked "${ipc} media toggle";
                "XF86AudioNext" = locked "${ipc} media next";
                "XF86AudioPrev" = locked "${ipc} media previous";
              };

              _children = [
                {
                  window-rule._children = [
                    { match._props.app-id = "^dev\\.noctalia\\.Noctalia$"; }
                    { open-floating = true; }
                  ];
                }
              ];
            };
          })
        ];
      };
  };
}
