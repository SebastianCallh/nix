{ config, pkgs, inputs, ... }:

let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "seb";
  hostname = "unidel";
  terminal = "kitty";
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

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
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
  sound.enable = true; 
  hardware.pulseaudio.enable = false;
  services.pipewire = { 
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.mpd = {
    enable = true;
    user = username;
    musicDirectory = "/home/${username}/Music/";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  
    network.listenAddress = "any"; 
    startWhenNeeded = true; 
  };

  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    # User-id 1000 must match user in `services.mpd.user`
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  # Configure keymap in X11
  #services.xserver = {
  #  xkb.layout = "us";
  #  xkb.variant = "";
  #};
  
  user.enable = true;
  user.name = "${username}";
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "${username}" = import ./home.nix;
    };
  };

  hardware.bluetooth.enable = true;
  hardware.opengl.enable = true; # needed for wayland WMs
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    dconf 
    wl-clipboard

    # ui 
    hyprpaper
    hyprland
    sway
    waybar
    wofi
  ];

  programs.zsh = {
    enable = true;
  };

  # for screen sharing
  xdg = { 
    portal = {
      enable = true;
      wlr.enable = true;
      # config.commons.default = "xdg-desktop-portal-hyprland";
      config.commons.default = "xdg-desktop-portal-wlr";
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = session;
        user = username;
      };
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
        user = "greeter";
      };
    };
  };

  environment.sessionVariables = {
    TERM=terminal;

    NIXOS_OZONE_WL = "1"; # tell electron apps to use wayland

    # try to solve 'wlr_gles2_renderer_create_with_drm_fd() failed!'
    # https://www.reddit.com/r/hyprland/comments/16rjanl/comment/k27j8bp/
    # WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };
  #. Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
