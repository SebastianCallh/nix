{ lib, config, pkgs, ...}:
let 
  cfg = config.zsa;
in
{
  options.zsa = {
    enable = lib.mkEnableOption "enable ZSA module";
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.zsa.enable = true;

    # keymapp is the software used to inspect and flash ZSA keyboards
    environment.systemPackages = [ pkgs.keymapp ];
  };
}
