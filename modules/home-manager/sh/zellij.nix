{ config, lib, ... }:
let
  cfg = config.zellij;
in
{
  options.zellij = with lib; {
    # theme = mkOption {
    #   type = types.enum [ "light" "dark" ];  
    # };

    # theme_name = mkOption {
    #   readOnly = true;
    #   type = types.str;
    #   default = {
    #     "light" = "catppuccin-latte";
    #     "dark" = "catppuccin-mocha";
    #   }."${cfg.theme}";
    # };
  };

  config = {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      # settings = {
      #   theme = cfg.theme_name;
      # };
    };
  };
}
