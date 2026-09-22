{ inputs, ... }:
let
  username = "seb";
  hostname = "violin";
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/_nixos/core.nix
      ../../modules/_nixos/bluetooth.nix
      ../../modules/_nixos/audio.nix
      ../../modules/_nixos/network.nix
      ../../modules/_nixos/docker.nix
      ../../modules/_nixos/zsa.nix
      inputs.home-manager.nixosModules.default
    ];
  
  home-manager = {
    extraSpecialArgs = { 
      inherit inputs;
      username = username;
    };
    users = {
      "${username}" = import ./home.nix;
    };
  };

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

  zsa.enable = true;
  bluetooth.enable = true;

    
  docker = {
    enable = true;
    userName = username;
  };
  
  # shells need to be enabled system-wide and not only in home manager
  # https://nixos.wiki/wiki/Command_Shell
  programs.zsh.enable = true;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
