{config, lib, pkgs, ...}:
let
  cfg = config.coding;
in
{
  options.coding = with lib; {
    enable = mkEnableOption "enable";

    enableAider = {
      type = types.bool;
    };
  };
  
  config = lib.mkIf cfg.enable {
      home.packages = [ pkgs.aider-chat ];
  };
}
