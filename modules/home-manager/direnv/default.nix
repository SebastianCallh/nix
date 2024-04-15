{config, lib, ...}:
let
cfg = config.direnv;
in
{
  options.direnv = with lib; {};

  config = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
