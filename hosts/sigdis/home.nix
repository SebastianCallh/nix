{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ../../modules/home-manager/helix
    ../../modules/home-manager/zsh
  ];

  home.packages = with pkgs; [
    lazygit
    ripgrep
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
