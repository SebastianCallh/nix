{config, lib, pkgs, ...}:
let
  cfg = config.coding;
in
{
  options.coding = with lib; {
    enable = mkEnableOption "enable";

    enableAider = mkOption {
      type = types.bool;
      default = true;
    };
  };
  
  config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        devenv
        claude-code

        # these are needed to build many python dependencies
        stdenv.cc.cc.lib
        zlib
        expat
        glib
      ] ++ lib.optionals cfg.enableAider [
        pkgs.aider-chat
      ];
  };
}
