{ config, pkgs, lib, builtins, inputs, username, ... }:
let
  background = ../../images/nixos-blue.png;
  fontName = "Hack Nerd Font Mono";
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../modules/home-manager/desktop
    ../../modules/home-manager/styling
    ../../modules/home-manager/firefox
    ../../modules/home-manager/syncthing
    ../../modules/home-manager/editor/helix
    ../../modules/home-manager/sh
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
 
  nixpkgs.config = { 
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
    ];
  };

  desktop = {
    terminal = lib.getExe config.sh.package;
    background = background;
    colorScheme = config.colorScheme;
    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        wallpaper = background;
        x = 0;
        y = 1440;
      }
      {
        name = "DP-1";
        width = 2560;
        height = 1440;
        wallpaper = background;
        x = 0;
        y = 0;
      }
    ];

    lockscreen = {
      background = background;
      timeout = 120;
    };

    wofi.font = {
      name = fontName;
      size = 18;
    };
  };

  sh = {
    terminal = "kitty";
    shell = "zsh";
  };
  
  kitty = {
    theme = "Ayu Mirage";
    font = {
      name = fontName;
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
