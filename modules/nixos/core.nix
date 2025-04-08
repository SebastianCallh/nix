{ lib, config, ...}:
let 
  cfg = config.core;
in
{
  options.core = {
    gc = lib.mkEnableOption "Enable automatic garbage collection";
  };

  config = lib.mkIf cfg.gc {
    # https://discourse.nixos.org/t/no-space-left-on-boot/24019/5
    nix.gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--delete-older-than 14d";    
    };
  };
}
