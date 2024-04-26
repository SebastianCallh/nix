{ config, lib, ... }:
let
  cfg = config.kitty;
in
{
  options.kitty = with lib; {
    theme = mkOption {
      type = types.str;
      default = "Ayu Mirage";
    };
    
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
      theme = cfg.theme;
      font = cfg.font;
    };
  };
}
