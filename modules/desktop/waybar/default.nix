# The waybar desktop shell and the hyprland compositor, as one bundle.
#
# These were never really separable: the bar, launcher, notification daemon,
# wallpaper, idle handler and lockscreen are all hypr* tools configured against
# each other. Hosts that want this stack import this aspect; hosts that want
# noctalia import that instead and evaluate none of it.
{ config, ... }:
{
  flake.modules = {
    nixos.waybar = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.waybar ];
    };

    homeManager.waybar =
      { pkgs, ... }:
      {
        desktop.lockCommand = "${pkgs.hyprlock}/bin/hyprlock";

        xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      };
  };
}
