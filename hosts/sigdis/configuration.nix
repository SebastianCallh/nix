{ config, pkgs, lib, inputs, ... }:

let
  username = "seb";
  hostname = "sigdis";
  terminal = "foot";
  editor = "hx";
  browser = "firefox";
in

{
  imports = [];
  
  users.users.seb = {
    name = "seb";
    home = "/Users/seb";
  };

  home-manager.users.seb = import ./home.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.zsh.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
