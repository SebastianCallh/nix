{
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.blueman ];

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };

      services.blueman.enable = true;
    };
}
