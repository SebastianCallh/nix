{ pkgs, lib, config, ...}:
let 
  cfg = config.bluetooth;
in
{
  options.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.blueman ];
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true; # Show battery charge of Bluetooth devices
        };
      };
    };
  
    services.blueman.enable = true;
  };
}
