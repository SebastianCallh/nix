{ pkgs, lib, config, ...}:
let 
  cfg = config.core;
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "Hyprland"; # logging out and in does not work with the pkgs prefix for some reason
in
{
  options.core = {
    enable = lib.mkEnableOption "Enable core module. Very important.";
    gc = lib.mkEnableOption "Enable automatic garbage collection";
    username = with lib; mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # https://discourse.nixos.org/t/no-space-left-on-boot/24019/5
    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
      gc = lib.mkIf cfg.gc {
        automatic = true;
        randomizedDelaySec = "14m";
        options = "--delete-older-than 14d";    
      };

      extraOptions = ''
        trusted-users = root seb
      '';
    };

    nixpkgs.config.allowUnfree = true;

    # this is needed to fix 'wlr_gles2_renderer_create_with_drm_fd() failed'
    # when using hyprland
    # hardware.opengl.enable = true; this is depricated in favor of hardware.graphics.enable;
    hardware.graphics.enable = true;

    time.timeZone = "Europe/Stockholm";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };

    environment.systemPackages = with pkgs; [
      dconf
      wl-clipboard
      brightnessctl
      playerctl
      libnotify
      xdg-utils # provides xgd-open and more
      qt5.qtwayland
      qt6.qtwayland
      libappindicator # tray icons
      swaynotificationcenter
    ];

    security.polkit.enable = true; # privilege manager

    # https://discourse.nixos.org/t/swaylock-wont-unlock/27275/3
    security.pam.services.swaylock = {};
  
    # Greeter should probably be put in its own service
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = session;
          user = cfg.username;
        };

        default_session = {
          command = "${tuigreet} --greeting 'Greetings' --asterisks --remember --remember-user-session --time --cmd ${session}";
          user = "greeter";
        };
      };
    };

    environment.variables = {
      NIXOS_OZONE_WL = "1"; # tell electron apps to use wayland
    };

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
    ];
  };
}
