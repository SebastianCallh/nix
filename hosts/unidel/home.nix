{ config, pkgs, lib, builtins, inputs, username, ... }:
let theme = "light";
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.catppuccin.homeManagerModules.catppuccin
    ../../modules/home-manager/desktop
    ../../modules/home-manager/firefox
    ../../modules/home-manager/syncthing
    ../../modules/home-manager/editor/helix
    ../../modules/home-manager/sh
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  xdg.enable = true; # required for catppuccin/nix theming
  
  nixpkgs.config = { 
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
      "steam"
      "steam-original"
      "steam-run"
    ];
  };

  desktop = {
    theme = theme;
    terminal = lib.getExe config.sh.package;
    monitors = [
      {
        name = "eDP-1";
        resolution = "preferred";
        wallpaper = config.styling.wallpaper;
        x = 0;
        y = 1440;
      }
    ];

    lockscreen = {
      wallpaper = config.styling.wallpaper;
      timeout = 120;
    };

    wofi.font = {
      name = config.styling.fontName;
      size = 18;
    };
  };

  sh = {
    terminal = "kitty";
    shell = "zsh";
  };
  
  kitty = {
    font = {
      name = config.styling.fontName;
      size = 18;
    };
  };
  
  home.packages = with pkgs; [
    curl
    neofetch
    discord
    obsidian
    lazygit
    nil
    ripgrep
    
    file
    killall
   (nerdfonts.override {
      fonts = [
        "FiraCode"
        "SpaceMono"
        "Iosevka"
        "Monoid"
        "Hack"
      ];
    })
  ];
  
  programs.git = {
    enable = true;
    userName = "Sebastian Callh";
    userEmail = "sebastian.callh@gmail.com";
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
    };
  };
  
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
