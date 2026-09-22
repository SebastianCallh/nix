{ config, pkgs, lib, inputs, ... }:
let
  darkMode = true;
  # See nixpkgs-gcloud in flake.nix: pinned nixpkgs just for google-cloud-sdk.
  pkgs-gcloud = import inputs.nixpkgs-gcloud {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.stylix.homeModules.stylix
  ];


  desktop = {
    theme = if darkMode then "catppuccin-mocha" else "catppuccin-latte";
    terminal = config.sh.command;
    monitors = [
      {
        name = "eDP-1";
        resolution = "preferred";
        wallpaper = config.styling.wallpaper;
        position = "auto-down";
      }
    ];

    lockscreen = {
      wallpaper = config.styling.wallpaper;
      timeout = 5 * 60;
    };
  };

  git = {
    userEmail = "sebastian.callh@gmail.com";
    enableDelta = true;
    deltaLight = !darkMode;
    enableLazygit = true;
  };

  jujutsu.userEmail = "sebastian.callh@gmail.com";

  
  sh.terminal = "ghostty";

  
   
  home.packages = with pkgs; [
    libreoffice
    slack
    (pkgs-gcloud.google-cloud-sdk.withExtraComponents [pkgs-gcloud.google-cloud-sdk.components.gke-gcloud-auth-plugin])
    crawl
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
