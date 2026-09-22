{ ... }:
{
  flake.modules.homeManager.waybar =
    { config, ... }:
    let
      monitors = map (m: { inherit (m) name wallpaper; }) config.desktop.monitors;
    in
    {
      services.hyprpaper = {
        enable = true;
        settings = {
          ipc = "off";
          splash = false;
          preload = map (m: toString m.wallpaper) monitors;
          wallpaper = map (m: "${m.name},${toString m.wallpaper}") monitors;
        };
      };
    };
}
