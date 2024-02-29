{ config, lib, ... }:
let
  cfg = config.hypridle;
in
{
  options.hypridle = with lib; {
    timeout = mkOption {
      type = types.int;
    };
  };

  config = {
    services.hypridle = {
      enable = true;
      listeners = [
        {
          timeout = cfg.timeout;
        }
      ];
    };
  };
}
