{ inputs, ... }:
let
  username = "seb";
  hostname = "mad";
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/_nixos/core.nix
    ];
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "${username}" = import ./home.nix;
    };
  };

  core = {
    enable = true;
    username = username;
    gc = true;
  };

  networking.hostName = hostname;


    
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
