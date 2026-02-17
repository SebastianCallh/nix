{ lib, config, pkgs, ...}:
let 
  cfg = config.jetbrains;
in
{
  options.jetbrains = {
    enable = lib.mkEnableOption "enable jetbrains module";
    datagrip.enable = lib.mkEnableOption "enable jetbrains datagrip";
    dataspell.enable = lib.mkEnableOption "enable jetbrains dataspell";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      lib.optionals cfg.datagrip.enable [ pkgs.jetbrains.datagrip ]
      ++ lib.optionals cfg.dataspell.enable [ pkgs.jetbrains.dataspell ];
  };
}
