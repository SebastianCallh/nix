{ config, pkgs, builtins, ... }:

{
programs.waybar = {
  enable = true;
  settings = {
    mainBar = {
    layer = "top";
    position = "top";
    height = 30;
    modules-left = ["hyprland/workspaces"];
    };
  };

  style = ''
     * {
       border: none;
       border-radius: 0;
       font-family: Fira Code;
     }
     window#waybar {
       background: #16191C;
       color: #AAB2BF;
     }
     #workspaces button {
       padding: 0 5px;
     }
  '';
};
}
