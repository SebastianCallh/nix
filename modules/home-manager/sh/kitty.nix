{ config, lib, ... }:
let
  cfg = config.kitty;
in
{
  options.kitty = with lib; {
    font = mkOption {
      type = hm.types.fontType;
      default = {
        name = "consolas";
        size = 10;
      };
    };
  };

  config = {
    programs.kitty = {
      enable = true;
      font = cfg.font;
    };
  };
}
