{ pkgs, lib, config, ...}:
let 
  cfg = config.audio;
in
{
  options.audio = {
    enable = lib.mkEnableOption "Enable audio";
    username = with lib; mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pavucontrol ];
    services.pulseaudio.enable = false;
    services.pipewire = { 
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    services.mpd = {
      enable = true;
      user = cfg.username;
      startWhenNeeded = true; 
      settings = {
        bind_to_address = "any"; 
        music_directory = "/home/${cfg.username}/Music/";
        audio_output = [
          {
            type = "pipewire";
            name = "PipeWire Output";
          }
        ];
      };
    };

    systemd.services.mpd.environment = {
      # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
      # User-id 1000 must match user in `services.mpd.user`
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };
}
