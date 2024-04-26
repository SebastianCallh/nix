{ config, pkgs, lib, inputs, ... }:

let
  username = "seb";
  hostname = "sigdis";
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
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "seb" ];
  };

  # Even though we enable zsh in our homd config this is needed. 
  # it sets up /etc/zshenv, /etc/zshrc to add /run/current-system/sw/bin to PATH and set other NIX-related envs
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    podman
    google-cloud-sdk
  ];
  
  environment.variables = {
    BROWSER = browser;
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config = {
    allowUnfree = true;
  };
  nix.package = pkgs.nix;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
