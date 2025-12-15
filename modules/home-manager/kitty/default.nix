{config, pkgs, lib, ...}:

let
cfg = config.kitty;
in
{
  options.kitty = with lib; {
    font = mkOption {
      type = hm.types.fontType;
      default = "consolas";
    };
  };

  config = {
    programs.kitty = {
      enable = true;
      font = cfg.font;
    };
   };
}
