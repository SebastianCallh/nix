{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ../../modules/home-manager/helix
    ../../modules/home-manager/zsh
    ../../modules/home-manager/kitty
  ];
  
  home.packages = with pkgs; [
    lazygit
    ripgrep
  ];

  kitty.theme = "Ayu Mirage";
  programs.home-manager.enable = true;
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
