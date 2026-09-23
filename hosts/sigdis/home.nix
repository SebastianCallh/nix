{ config, pkgs, inputs, lib, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    lazygit
    ripgrep
    slack-term
    visidata
    devenv
    file
    killall
    pyright
    (pkgs.nerdfonts.override { fonts = ["Terminus" "Hack"]; })
  ];

  helix.git_tui = "lazygit";
  helix.theme = "ayu_light";
  helix.defaultEditor = true;
  
  terminal.program = "kitty";
  terminal.font = {
    name = "Terminess Nerd Font Mono";
    size = 20;
  };
    
  programs.home-manager.enable = true;
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
