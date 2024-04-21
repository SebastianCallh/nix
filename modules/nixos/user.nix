{ lib, config, pkgs, ...}:
let 
  cfg = config.user;
in
{
  options.user = with lib; {
    enable = mkEnableOption "enable user module";
    
    name = mkOption {
      description = ''
        Name of user
      '';
    };

    autologin = mkOption {
      type = types.bool;
      default = false;
    };
 };

  config = lib.mkIf cfg.enable {
    services.getty.autologinUser = 
      if cfg.autologin
      then cfg.name
      else null;
      
    users.users.${cfg.name} = {
      isNormalUser = true;
      initialPassword = "12345";
      extraGroups = [ "networkmanager" "wheel" "plugdev" "input" ];
      shell = pkgs.zsh;
    };
  };
}
