{ pkgs, config, lib, ... }:
let
  cfg = config.corepackages;
in
{
  options.corepackages = with lib; {
    enable = mkEnableOption "enable";
  };

  config = lib.mkIf cfg.enable {

    nixpkgs.config = { 
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "discord"
        "obsidian"
        "slack"
        "spotify"
      ];
    };

    home.packages = with pkgs; [
      # cli tools
      curl
      neofetch
      nil
      ripgrep
      grimblast
      dconf # https://github.com/nix-community/home-manager/issues/3113
      tree
      file
      killall
      nerd-fonts.fira-code
      nerd-fonts.space-mono
      nerd-fonts.iosevka
      nerd-fonts.monoid
      nerd-fonts.hack
      bottom

      # graphical programs
      spotify
      obsidian
    ];
  };
}
