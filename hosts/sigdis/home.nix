{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ../../modules/home-manager/editor/helix
    ../../modules/home-manager/direnv
    ../../modules/home-manager/sh
    ../../modules/home-manager/kitty
  ];
  
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    lazygit
    ripgrep
    slack-term
    visidata
    devenv
    nodePackages.pyright
    (pkgs.nerdfonts.override { fonts = ["Terminus" "Hack"]; })
  ];

  helix.git_tui = "lazygit";
  helix.theme = "ayu_light";
  helix.defaultEditor = true;
  
  kitty.theme = "Ayu Light";
  kitty.font = {
    name = "Terminess Nerd Font Mono";
    size = 20;
  };
    
  programs.home-manager.enable = true;
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
