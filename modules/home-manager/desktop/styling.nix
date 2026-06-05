{ pkgs, config, lib, ... }: 
let
  cfg = config.styling;
  c = config.lib.stylix.colors;
  # xdg-desktop-portal-gtk (active for the FileChooser) makes Firefox read its
  # light/dark preference from dconf instead of the GTK config files. Stylix
  # only sets this key via its gnome target, which is off on Hyprland, so the
  # portal reports "no preference" and Firefox renders unstyled. Derive the
  # polarity from the scheme background luminance and set the key ourselves.
  # See https://github.com/nix-community/stylix/issues/2071
  isDark =
    (lib.toInt c."base00-rgb-r" + lib.toInt c."base00-rgb-g" + lib.toInt c."base00-rgb-b") < 384;
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

    wallpaper = mkOption {
      readOnly = true;
      type = types.path;
      default = ../../../images/theme-wallpapers/${cfg.theme}.png;
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
      image = cfg.wallpaper;
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

    # mkForce because stylix's gnome target also sets this key (to "default"
    # whenever stylix.polarity isn't explicitly "dark"), which is the root cause.
    dconf.settings."org/gnome/desktop/interface".color-scheme =
      lib.mkForce (if isDark then "prefer-dark" else "prefer-light");
    
    fonts.fontconfig.enable = true;
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 24;
    };
  };
}
