{ config, ... }:
{
  config = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      settings = {
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
