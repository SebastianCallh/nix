{ config, lib, pkgs, ... }: 
let
  cfg = config.sh;
in
{
  imports = [
    ./kitty.nix
    ./zsh.nix
  ];

  options.sh = with lib; {
    terminal = mkOption {
      type = types.enum [ "kitty" ];
    };
    
    shell = mkOption {
      type = types.enum [ "zsh" ];
    };

    package = mkOption {
      readOnly = true;
      type = types.package;
      default = {
        "kitty" = pkgs.kitty;
      }."${cfg.terminal}";
    };
   };

  config = {
    home.sessionVariables.TERM = config.sh.terminal;
    zsh.enable = config.sh.shell == "zsh";
  };
}
