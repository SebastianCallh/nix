{ ... }:
{
  flake.modules.homeManager.waybar =
    { config, lib, pkgs, ... }:
    {
      # noctalia ships its own session panel, so hyprshutdown is only needed
      # alongside the waybar stack.
      home.packages = [ pkgs.hyprshutdown ];
    };
}
