{ lib, config, pkgs, ...}:
let 
  cfg = config.user;
in
{
  options.user = {
    enable = lib.mkEnableOption "enable user module";
      name = lib.mkOption {
      description = ''
        Name of user
      '';
    };
 };

  config = lib.mkIf cfg.enable {
    services.getty.autologinUser = cfg.name; 
    users.users.${cfg.name} = {
      isNormalUser = true;
      initialPassword = "12345";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
  };
}
