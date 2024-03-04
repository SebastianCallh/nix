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
  };

  config = {
    programs.kitty = {
      enable = true;
      theme = cfg.theme;
    };
   };
}
