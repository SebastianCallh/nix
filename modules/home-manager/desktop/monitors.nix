{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.desktop.monitors = mkOption {
    type = types.listOf (types.submodule {
      options = {
        name = mkOption {
          type = types.str;
          example = "DP-1";
        };
        width = mkOption {
          type = types.int;
          example = 1920;
        };
        height = mkOption {
          type = types.int;
          example = 1080;
        };
        scale = mkOption {
          type = types.str;
          default = "1";
        };
        refreshRate = mkOption {
          type = types.int;
          default = 60;
        };
        wallpaper = mkOption {
          type = types.path;
          default = null;
        };
        x = mkOption {
          type = types.int;
          default = 0;
        };
        y = mkOption {
          type = types.int;
          default = 0;
        };
        enabled = mkOption {
          type = types.bool;
          default = true;
        };
      };
    });
    default = [ ];
  };
}
