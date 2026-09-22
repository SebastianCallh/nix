# The waybar desktop shell and the hyprland compositor, as one bundle.
#
# These were never really separable: the bar, launcher, notification daemon,
# wallpaper, idle handler and lockscreen are all hypr* tools configured against
# each other. Hosts that want this stack import this file; hosts that want
# noctalia import that instead and evaluate none of it.
{ config, pkgs, lib, ... }:
let
  cfg = config.desktop;
in
{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprshutdown.nix
    ./hyprsunset.nix
    ./swaync.nix
    ./wofi.nix
    ./waybar
  ];

  config = {
    desktop.lockCommand = "${pkgs.hyprlock}/bin/hyprlock";

    hyprland = {
      terminal = cfg.terminal;
      lockCommand = cfg.lockCommand;
    };

    hypridle = {
      timeout = cfg.lockscreen.timeout;
      lockCommand = cfg.lockCommand;
    };

    hyprpaper.monitors = map (m: { inherit (m) name wallpaper; }) cfg.monitors;

    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
