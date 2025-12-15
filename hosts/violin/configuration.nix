{ inputs, ... }:
let
  username = "seb";
  hostname = "violin";
  editor = "hx";
  browser = "firefox";
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/nixos/core.nix
      ../../modules/nixos/user.nix
      ../../modules/nixos/bluetooth.nix
      ../../modules/nixos/audio.nix
      ../../modules/nixos/network.nix
      ../../modules/nixos/docker.nix
      ../../modules/nixos/zsa.nix
      inputs.home-manager.nixosModules.default
    ];

  core = {
    enable = true;
    username = username;
    gc = true;
  };

  audio = {
    enable = true;
    username = username;
  };

  network = {
    enable = true;
    hostname = hostname;
  };
  
  home-manager = {
    extraSpecialArgs = { 
      inherit inputs;
      username = username;
    };
    users = {
      "${username}" = import ./home.nix;
    };
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # tell electron apps to use wayland
    EDITOR = editor;
    VISUAL = editor;
    BROWSER = browser;
  };

  zsa.enable = true;
  bluetooth.enable = true;

  user = {
    enable = true;
    name = username;
    autologin = false;
  };
    
  docker = {
    enable = true;
    userName = username;
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
