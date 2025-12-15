{ pkgs, config, lib, ... }: 
let
  cfg = config.styling;
in
{
  options.styling = with lib; {
    font = mkOption {
      readOnly = true;
      type = types.str;
      default = "Fira Code";
    };
    
    theme = mkOption {
      type = types.str;
      default = "catppuccin-latte";
    };
  };
  
  config = {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
      image = ../../../images/theme-wallpapers/${cfg.theme}.png;
      targets = {
        firefox = {
          enable = true;
          profileNames = [ "seb" ];
        };
        wofi.enable = false; # custom style in wofi module
      };

      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "${cfg.font} Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "${cfg.font} Sans";
        };

        monospace = {
          package = pkgs.dejavu_fonts;
          name = "${cfg.font} Sans Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    gtk = {
      enable = true;
    };
    
    fonts.fontconfig.enable = true;
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 24;
    };
  };
}
