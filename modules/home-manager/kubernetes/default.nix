{config, lib, pkgs, ...}:
let
  cfg = config.kubernetes;
in
{
  options.kubernetes = with lib; {
    enable = mkEnableOption "enable";
  };

  config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        kubectl
        k9s
        kubernetes-helm
      ];
  };
}
