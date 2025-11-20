{ config, pkgs, lib, builtins, inputs, username, ... }:
let 
  theme = "dark";
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
    inputs.catppuccin.homeModules.catppuccin
    ../../modules/home-manager/desktop
    ../../modules/home-manager/git
    ../../modules/home-manager/coding
    ../../modules/home-manager/firefox
    ../../modules/home-manager/syncthing
    ../../modules/home-manager/direnv
    ../../modules/home-manager/editor/helix
    ../../modules/home-manager/sh
    ../../modules/home-manager/dockertools
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  # xdg.enable = true; # required for catppuccin/nix theming
  
  xdg = { 
    portal = {
      enable = true;
      # wlr.enable = true;
      xdgOpenUsePortal = true;
      # config.commons.default = "xdg-desktop-portal-hyprland";
      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
        default = "*";
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    # mime = {
    #   enable = true;
    #   defaultApplications = {
    #     "text/markdown" = [editor];
    #   };
    # };
  };

  nixpkgs.config = { 
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
      "slack"
      "spotify"
    ];
  };

  desktop = {
    theme = theme;
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

    wofi.font = {
      name = config.styling.fontName;
      size = 18;
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
    theme = theme;
    terminal = "ghostty";
    shell = "zsh";
    # multiplexer = "none";
  };
  
  dockertools.enable = true;
    
  home.packages = with pkgs; [
    curl
    neofetch
    obsidian
    nil
    ripgrep
    grimblast
    devenv
    libreoffice
    spotify
    dconf # https://github.com/nix-community/home-manager/issues/3113
    tree
    file
    killall
    zed-editor-fhs
    nerd-fonts.fira-code
    nerd-fonts.space-mono
    nerd-fonts.iosevka
    nerd-fonts.monoid
    nerd-fonts.hack
    postman
    claude-code
    bottom

    # these are needed to build many python dependencies
    stdenv.cc.cc.lib
    zlib
    expat
    glib
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
