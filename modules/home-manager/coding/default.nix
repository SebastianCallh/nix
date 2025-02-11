{config, lib, ...}:
let
cfg = config.coding;
in
{
  options.coding = with lib; {
    enable = mkEnableOption "enable";
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };
  };
}
