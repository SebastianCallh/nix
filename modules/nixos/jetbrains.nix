{ lib, config, pkgs, ...}:
let 
  cfg = config.jetbrains;
in
{
  options.jetbrains = {
    enable = lib.mkEnableOption "enable jetbrains module";
    datagrip.enable = lib.mkEnableOption "enable jetbrains datagrip";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkIf cfg.datagrip.enable [ pkgs.jetbrains.datagrip ];
  };
}
