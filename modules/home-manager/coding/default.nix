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
      home.packages = with pkgs; [
        devenv
        aider-chat
        claude-code

        # these are needed to build many python dependencies
        stdenv.cc.cc.lib
        zlib
        expat
        glib
      ];
  };
}
