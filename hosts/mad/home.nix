{ config, pkgs, lib, inputs, username, full_name, email, ... }:
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
    ../../modules/_home-manager/desktop
    ../../modules/_home-manager/corepackages
    ../../modules/_home-manager/jujutsu
    ../../modules/_home-manager/coding
    ../../modules/_home-manager/firefox
    ../../modules/_home-manager/syncthing
    ../../modules/_home-manager/devenv
    ../../modules/_home-manager/editor/helix
    ../../modules/_home-manager/sh
    ../../modules/_home-manager/dockertools
    ../../modules/_home-manager/kubernetes
  ];

  corepackages.enable = true;

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

  jujutsu = {
    enable = true;
    userName = full_name;
    userEmail = email;
  };

  helix = {
    enable = true;
    defaultEditor = true;
  };
  
  coding.enable = true;
  devenv = {
    enable = true;
    enableZshIntegration = true;
  };
  sh = {
    terminal = "ghostty";
    shell = "zsh";
  };

  herdr.enable = true;
  
  dockertools.enable = true;
  kubernetes.enable = true;
   
  home.packages = with pkgs; [
    libreoffice
    slack
    (pkgs-gcloud.google-cloud-sdk.withExtraComponents [pkgs-gcloud.google-cloud-sdk.components.gke-gcloud-auth-plugin])
    crawl
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
