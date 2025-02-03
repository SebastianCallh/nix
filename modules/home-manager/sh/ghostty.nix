{ config, lib, ... }:
let
  cfg = config.ghostty;
in
{
  options.ghostty = with lib; {

    theme = mkOption {
      type = types.enum [ "light" "dark" ];  
    };

    theme_name = mkOption {
      readOnly = true;
      type = types.str;
      default = {
        "light" = "catppuccin-latte";
        "dark" = "catppuccin-frappe";
      }."${cfg.theme}";
    };

    font = mkOption {
      type = hm.types.fontType;
      default = {
        name = "consolas";
        size = 12;
      };
    };
  };

  config = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = cfg.theme_name;
        font-family = cfg.font.name;
        font-size = cfg.font.size;
      };
    };
  };
}
