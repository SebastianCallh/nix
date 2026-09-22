{ pkgs, lib, config, ...}:
let 
  cfg = config.network;
in
{
  options.network = {
    enable = lib.mkEnableOption "Enable networking";
    hostname = with lib; mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.networkmanagerapplet ];
    networking.hostName = cfg.hostname;
    networking.networkmanager.enable = true;

    # Enables wireless support via wpa_supplicant.
    # networking.wireless.enable = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
