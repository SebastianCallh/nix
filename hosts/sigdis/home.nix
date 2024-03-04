{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ../../modules/home-manager/helix
    ../../modules/home-manager/sh
    ../../modules/home-manager/kitty
  ];
  
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    lazygit
    ripgrep
    (pkgs.nerdfonts.override { fonts = ["Terminus" "Hack"]; })   
  ];

  helix.theme = "catppuccin_macchiato";
  kitty.theme = "Catppuccin-Macchiato";
  kitty.font = {
    name = "Terminess Nerd Font Mono";
    size = 20;
  };
    
  programs.home-manager.enable = true;
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
