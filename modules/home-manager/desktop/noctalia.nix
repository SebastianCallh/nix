{ config, lib, ... }:
let
  cfg = config.desktop;
in
{
  # Theme, font family, wallpaper path and surface opacities all come from the
  # stylix noctalia target, so they are deliberately absent here.
  config = lib.mkIf (cfg.shell == "noctalia") {
    # The stylix hyprland target turns hyprpaper on whenever stylix.image is
    # set; noctalia draws the wallpaper itself.
    stylix.targets.hyprland.hyprpaper.enable = false;

    # Stylix leaves polarity at "either" unless told otherwise, and its
    # noctalia target only emits a dark palette variant while picking light
    # mode for anything but an explicit "dark". Set here rather than in
    # styling.nix so the hosts still on waybar keep their current theming.
    stylix.polarity = if config.styling.isDark then "dark" else "light";

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        shell = {
          polkit_agent = true;
          # Without this, apps started from the launcher die whenever the
          # noctalia user unit restarts.
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
          start = [ "workspaces" ];
          center = [ ];
          end = [ "tray" "ram" "cpu" "keyboard_layout" "battery" "clock" "control-center" ];
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
            timeout = cfg.lockscreen.timeout;
            action = "lock";
            enabled = true;
          };

          "screen-off" = {
            timeout = cfg.lockscreen.timeout + 60;
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
  };
}
