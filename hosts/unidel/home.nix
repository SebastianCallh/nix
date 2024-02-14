{ config, pkgs, lib, builtins, inputs, username, hostname, terminal, editor, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./hyprland.nix
    ./waybar.nix
    ./foot.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  fonts.fontconfig.enable = true;
  nixpkgs.config = { 
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "discord"
    ];
  };

  home.packages = with pkgs; [
    foot
    dolphin
    curl
    neovim
    neofetch 
    discord
    brave
    helix
    libnotify
    mako

   (nerdfonts.override {
      fonts = [
        "FiraCode"
        "SpaceMono"
        "Iosevka"
        "Monoid"
        "Hack"
      ];
    })
  ];
  
  programs.git = {
    enable = true;
    userName = "Sebastian Callh";
    userEmail = "sebastian.callh@gmail.com";

    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.firefox = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };


  # attempt to solve firefox saying "unable to load hand2 from the cursor theme"
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # tell electron apps to use wayland
    EDITOR = editor;
    TERM = terminal;
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
