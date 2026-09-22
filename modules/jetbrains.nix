{
  flake.modules.nixos = {
    datagrip =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jetbrains.datagrip ];
      };

    dataspell =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jetbrains.dataspell ];
      };
  };
}
