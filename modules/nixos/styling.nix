{ lib, config, pkgs, ...}:
let 
  cfg = config.styling;
in
{
  options.styling = {
    enable = lib.mkEnableOption "enable stylix module";
  };

  config = lib.mkIf cfg.enable {
    # stylix = {
    #   enable = true;
    #   autoEnable = false;
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    # };
  };
}
