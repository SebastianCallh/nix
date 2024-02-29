{config, pkgs, lib, ...}:

let
cfg = config.kitty;
in
{
  options.kitty = with lib; {
    theme = mkOption {
      type = types.string;
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
