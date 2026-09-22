{ config, ... }:
let
  username = config.identity.username;
in
{
  flake.modules.nixos.core =
    { pkgs, config, lib, ... }:
    let
      tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
      session = config.core.session;
    in
    {
      options.core.session = with lib; mkOption {
        type = types.str;
        default = "Hyprland";
        example = "niri-session";
        description = ''
          Command greetd launches for the graphical session. This has to be the
          bare executable name rather than a store path, because logging out and
          back in does not work when it carries the pkgs prefix.
        '';
      };

      config = {
        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # https://discourse.nixos.org/t/no-space-left-on-boot/24019/5
        nix = {
          settings.experimental-features = [ "nix-command" "flakes" ];
          gc = {
            automatic = true;
            randomizedDelaySec = "14m";
            options = "--delete-older-than 14d";
          };

          extraOptions = ''
            trusted-users = root ${username}
          '';
        };

        nixpkgs.config.allowUnfree = true;

        # this is needed to fix 'wlr_gles2_renderer_create_with_drm_fd() failed'
        # when using hyprland
        # hardware.opengl.enable = true; this is depricated in favor of hardware.graphics.enable;
        hardware.graphics.enable = true;

        time.timeZone = "Europe/Stockholm";
        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocales = [ "sv_SE.UTF-8/UTF-8" ];
          extraLocaleSettings = {
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
          loupe # image viewer
          ibusMinimal # to handle dead keys like tilde and backtick in gtk apps
        ];

        # Shim loader so unpatched dynamically-linked binaries (pip wheels,
        # vendor tools, jetbrains plugins) can find common libraries like
        # libstdc++.so.6 via NIX_LD_LIBRARY_PATH.
        programs.nix-ld = {
          enable = true;
          libraries = with pkgs; [
            stdenv.cc.cc.lib
            zlib
            openssl
            expat
            glib
            libGL
          ];
        };

        security.polkit.enable = true; # privilege manager

        security.pam.services.hyprlock = { };

        # Greeter should probably be put in its own service
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

        environment.variables = {
          NIXOS_OZONE_WL = "1"; # tell electron apps to use wayland
        };

        fonts.packages = with pkgs; [
          nerd-fonts.fira-code # one nerd font required for starship prompt
        ];

        # Kill memory-hogging processes before the system freezes
        services.earlyoom = {
          enable = true;
          freeMemThreshold = 5;
          freeSwapThreshold = 10;
          enableNotifications = true;
        };

        # mount usb drives
        services.udisks2.enable = true;
      };
    };
}
