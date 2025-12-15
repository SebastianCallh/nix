{ config, lib, ... }:
let
  cfg = config.zellij;
in
{
  config = {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
