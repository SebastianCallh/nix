{config, pkgs, lib, ...}:

let
cfg = config.kitty;
in
{
  options.kitty = with lib; {
    theme = mkOption {
      type = types.str;
      default = "base16_default";
    };
    
    font = mkOption {
      type = hm.types.fontType;
      default = "consolas";
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
