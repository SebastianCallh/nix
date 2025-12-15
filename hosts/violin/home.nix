{ config, pkgs, lib, inputs, username, ... }:
let 
  home_monitor = {
    x = 2560;
    y = 1440;
  };

  office_monitor = {
    x = 3840;
    y = 2160;
 };
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    ../../modules/home-manager/desktop
    ../../modules/home-manager/corepackages
    ../../modules/home-manager/git
    ../../modules/home-manager/coding
    ../../modules/home-manager/firefox
    ../../modules/home-manager/syncthing
    ../../modules/home-manager/direnv
    ../../modules/home-manager/editor/helix
    ../../modules/home-manager/sh
    ../../modules/home-manager/dockertools
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };

  corepackages.enable = true;

  desktop = {
    theme = "catppuccin-latte";
    terminal = lib.getExe config.sh.package;
    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        wallpaper = config.styling.wallpaper;
        position = "auto-down";
      }
      {
        name = "DP-1";
        width = office_monitor.x;
        height = office_monitor.y;
        wallpaper = config.styling.wallpaper;
        position = "auto-up";
      }
      {
        name = "HDMI-A-1";
        width = home_monitor.x;
        height = home_monitor.y;
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
    enable = true;
    userName = "Sebastian Callh";
    userEmail = "sebastian.callh@violet.ai";
    enableDelta = true;
    enableLazygit = true;
  };
  
  coding.enable = true;
  sh = {
    terminal = "ghostty";
    shell = "zsh";
  };
  
  dockertools.enable = true;
   
  home.packages = with pkgs; [
    libreoffice
    postman
    slack
  ];

  # shells need to be enabled system-wide and not only in home manager
  # https://nixos.wiki/wiki/Command_Shell
  programs.zsh.enable = true;
    
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
