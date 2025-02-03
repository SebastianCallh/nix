{ config, lib, pkgs, ... }: 
let
  cfg = config.sh;
in
{
  imports = [
    ./kitty.nix
    ./ghostty.nix
    ./zsh.nix
    # ./zellij.nix
  ];

  options.sh = with lib; {

    theme = mkOption {
      type = types.enum [ "light" "dark" ];  
    };

    terminal = mkOption {
      type = types.enum [ "kitty" "ghostty" ];
    };
    
    shell = mkOption {
      type = types.enum [ "zsh" ];
    };

    # multiplexer = mkOption {
    #   type = types.enum [ "none" "zellij" ];
    # };

    package = mkOption {
      readOnly = true;
      type = types.package;
      default = {
        "kitty" = pkgs.kitty;
        "ghostty" = pkgs.ghostty;
      }."${cfg.terminal}";
    };
   };

  config = {
    ghostty.theme = "dark";
    home.sessionVariables.TERM = config.sh.terminal;
    zsh.enable = config.sh.shell == "zsh";
  };
}
