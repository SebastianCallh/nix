{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    ../../modules/_home-manager/desktop
    ../../modules/_home-manager/desktop/waybar-stack.nix
  ];


  desktop = {
    theme = "ayu-mirage";
    terminal = config.sh.command;
    monitors = [
      {
        name = "eDP-1";
        resolution = "preferred";
        wallpaper = config.styling.wallpaper;
        position = "auto-down";
      }
      {
        name = "DP-1";
        resolution = "preferred";
        wallpaper = config.styling.wallpaper;
        position = "auto-up";
      }
      {
        name = "HDMI-A-1";
        resolution = "preferred";
        wallpaper = config.styling.wallpaper;
        position = "auto-up";
      }
    ];

    lockscreen = {
      wallpaper = config.styling.wallpaper;
      timeout = 5 * 60;
    };
  };

  git = {
    userEmail = "sebastian.callh@violet.ai";
    enableDelta = true;
    enableLazygit = true;
  };
  
  sh.terminal = "ghostty";

  
   
  home.packages = with pkgs; [
    libreoffice
    postman
    slack
  ];
    
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
