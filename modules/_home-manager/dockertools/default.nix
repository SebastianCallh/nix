{ pkgs, config, lib, ... }:
let
  cfg = config.dockertools;
in
{
  options.dockertools = with lib; {
    enable = mkEnableOption "enable";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.lazydocker
      pkgs.docker-buildx
    ];

    xdg.configFile."lazydocker/config.yml".source = (pkgs.formats.yaml { }).generate "config" {
      commandTemplates = {
        dockerCompose = "docker compose";
      };

      gui = {
        returnImmediately = true;
      };
    };
  };
}
