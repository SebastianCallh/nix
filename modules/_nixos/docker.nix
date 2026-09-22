{ lib, config,  ...}:
let 
  cfg = config.docker;
in
{
  options.docker = with lib; {
    enable = mkEnableOption "enable docker module";

    userName = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName}.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
    };
  };
}
