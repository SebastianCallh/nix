{
  flake.modules.nixos.network =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.networkmanagerapplet ];

      networking.networkmanager.enable = true;
    };
}
