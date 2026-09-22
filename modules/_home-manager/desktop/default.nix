# Values every desktop shares, regardless of which compositor or shell the host
# picks. The compositor and the shell are chosen by importing their modules, not
# by setting a flag here.
{ config, pkgs, lib, ... }:
let
  cfg = config.desktop;
in
{
  imports = [
    ./styling.nix
    ./monitors.nix
  ];

  options.desktop = with lib; {
    terminal = mkOption {
      type = types.str;
      description = ''
        Executable for the terminal to use.
      '';
    };

    lockCommand = mkOption {
      type = types.str;
      description = ''
        Command that locks the session. Contributed by the desktop shell, since
        that is what owns the lockscreen, and read by the compositor to bind it.
      '';
    };

    theme = mkOption {
      type = types.str;
      description = ''
        Theme to apply to the system.
      '';
    };

    wofi = {
      font = mkOption {
        type = hm.types.fontType;
        default = {
          name = "consolas";
          size = 10;
        };
      };
    };

    lockscreen = {
      wallpaper = mkOption {
        type = types.path;
      };

      timeout = mkOption {
        type = types.int;
      };
    };
  };

  config = {
    styling = {
      theme = cfg.theme;
    };

    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config.common = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
          default = "*";
        };
        # A compositor module appends whatever else it needs. The niri
        # home-manager module contributes xdg-desktop-portal-gnome, which is
        # what niri's own portals.conf expects for screencasting.
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };
    };
  };
}
