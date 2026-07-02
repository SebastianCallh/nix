{config, lib, pkgs, ...}:
let
  cfg = config.devenv;
in
{
  options.devenv = with lib; {
    enable = mkEnableOption "devenv";

    enableZshIntegration = mkOption {
      type = types.bool;
      default = config.programs.zsh.enable;
      description = ''
        Whether to add the devenv zsh hook (auto activation of devenv
        environments) to .zshrc.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.devenv ];

    programs.zsh.initExtra = lib.mkIf cfg.enableZshIntegration ''
      eval "$(devenv hook zsh)"
    '';
  };
}
