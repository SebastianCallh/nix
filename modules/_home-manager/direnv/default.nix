{config, lib, ...}:
let
cfg = config.direnv;
in
{
  options.direnv = {};

  config = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
    };
  };
}
