{ config, lib, ... }:
let
  cfg = config.ghostty;
in
{
  options.ghostty = with lib; {
    theme_name = mkOption {
      readOnly = true;
      type = types.str;
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
        font-family = cfg.font.name;
        font-size = cfg.font.size;
        gtk-tabs-location = "bottom";
        window-decoration = false;
        keybind = [
          # navigate splits
          "ctrl+h=goto_split:left"
          "ctrl+l=goto_split:right"
          "ctrl+j=goto_split:bottom"
          "ctrl+k=goto_split:top"

          #navigate tabs
          "alt+h=previous_tab"
          "alt+l=next_tab"

          # move tabs
          "alt+shift+h=move_tab:-1"
          "alt+shift+l=move_tab:1"
        ];
      };
    };
  };
}
