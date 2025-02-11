{config, lib, pkgs, ...}:
let
  cfg = config.coding;
in
{
  options.coding = with lib; {
    enable = mkEnableOption "enable";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ delta ];
    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format='lazygit-edit://{path}:{line}'";
          };
        };
      };
    };
  };
}
