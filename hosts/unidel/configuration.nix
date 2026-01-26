{ config, pkgs, inputs, ... }:
let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "seb";
  hostname = "unidel";
  editor = "hx";
  browser = "firefox";
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/nixos/user.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # audio
  hardware.pulseaudio.enable = false;
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
    user = username;
    musicDirectory = "/home/${username}/Music/";
    settings = {
      audio_output = "pipewire";
    };
  
    network.listenAddress = "any"; 
    startWhenNeeded = true; 
  };

  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    # User-id 1000 must match user in `services.mpd.user`
    XDG_RUNTIME_DIR = "/run/user/1000";
  };
  
  user = {
    enable = true;
    name = username;
    autologin = false;
  };
  
  home-manager = {
    extraSpecialArgs = { 
      inherit inputs;
      username = username;
    };
    users = {
      "${username}" = import ./home.nix;
    };
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # tell electron apps to use wayland
    EDITOR = editor;
    VISUAL = editor;
    BROWSER = browser;
  };

  hardware.graphics.enable = true; # needed for wayland WMs
  hardware.keyboard.zsa.enable = true;

  security.polkit.enable = true; # privilege manager
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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

    # networking
    networkmanagerapplet
    blueman

    # ui 
    hyprpaper
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.zsh.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
  # for screen sharing
  xdg = { 
    portal = {
      enable = true;
      wlr.enable = true;
      config.commons.default = "xdg-desktop-portal-hyprland";
    };

    mime = {
      enable = true;
      defaultApplications = {
        "text/markdown" = [editor];
      };
    };
  };

  # https://discourse.nixos.org/t/swaylock-wont-unlock/27275/3
  security.pam.services.swaylock = {};
  
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = session;
        user = username;
      };

      default_session = {
        command = "${tuigreet} --greeting 'Greetings' --asterisks --remember --remember-user-session --time --cmd ${session}";
        user = "greeter";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
