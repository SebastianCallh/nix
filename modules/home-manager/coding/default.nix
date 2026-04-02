{config, lib, pkgs, ...}:
let
  cfg = config.coding;
in
{
  options.coding = with lib; {
    enable = mkEnableOption "enable";
  };
  
  config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        devenv

        # these are needed to build many python dependencies
        stdenv.cc.cc.lib
        zlib
        expat
        glib
      ];

      programs.claude-code = {
        enable = true;
      };

      programs.gh = {
        enable = true;
      };
  };
}
