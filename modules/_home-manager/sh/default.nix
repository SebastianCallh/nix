{ config, lib, pkgs, ... }: 
let
  cfg = config.sh;
in
{
  imports = [
    ./kitty.nix
    ./ghostty.nix
    ./herdr.nix
    ./zsh.nix
    # ./zellij.nix
  ];

  options.sh = with lib; {
    terminal = mkOption {
      type = types.enum [ "kitty" "ghostty" ];
    };
    
    shell = mkOption {
      type = types.enum [ "zsh" ];
    };

    package = mkOption {
      readOnly = true;
      type = types.package;
      default = {
        "kitty" = pkgs.kitty;
        "ghostty" = pkgs.ghostty;
      }."${cfg.terminal}";
    };

    command = mkOption {
      readOnly = true;
      type = types.str;
      description = ''
        Command that opens a terminal. This is what the compositor should
        spawn, rather than the bare terminal binary: when herdr is enabled it
        wraps the terminal so the window comes up already attached to the
        persistent herdr session.
      '';
      default =
        let terminal = lib.getExe cfg.package;
        in if config.herdr.autoStart && config.herdr.enable
           then "${terminal} -e ${lib.getExe config.programs.herdr.package}"
           else terminal;
    };
   };

  config = {
    home.sessionVariables.TERM = config.sh.terminal;
    zsh.enable = config.sh.shell == "zsh";
  };
}
