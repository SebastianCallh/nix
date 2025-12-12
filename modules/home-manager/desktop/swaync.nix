{  ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = false;
      control-center-width = 500;
      control-center-height = 1025;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      widgets = [
        "title"
        "volume"
        "backlight"
        "dnd"
        "mpris"
        "notifications"
      ];
      widget-config = {
        title = {
          text = "Sidebar";
          clear-all-button = true;
          button-text = "󰆴 Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 1;
          text = "Notification Center";
        };
        mpris = {
          image-size = 96;
          image-radius = 7;
        };
        volume = {
          label = "󰕾";
        };
        backlight = {
          label = "󰃟";
        };
        buttons-grid = {
          actions = [
            { label = "⏹️"; command = "systemctl poweroff"; }
            { label = "🔄"; command = "systemctl reboot"; }
            { label = "🚪"; command = "hyprctl dispatch exit"; }
            { label = "🗃️"; command = "thunar"; }
            { label = "📸"; command = "gimp"; }
            { label = "📣"; command = "pactl set-sink-mute @DEFAULT_SINK@ toggle"; }
            { label = "🎙️"; command = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"; }
            { label = "🎮"; command = "steam"; }
            { label = "🌏"; command = "firefox"; }
            { label = "📹"; command = "obs"; }
          ];
        };
      };
    };
  };
}
