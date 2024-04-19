{ pkgs, config, ... }: 
{
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Teal-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "teal" ];
        size = "standard";
        tweaks = [ "black" ];
        variant = "macchiato";
      };
    };
  };
  
  home.file = {
    ".config/colors.css".text = ''
      @define-color base #${config.colorScheme.palette.base00};
      @define-color mantle #${config.colorScheme.palette.base01};
      @define-color surface0 #${config.colorScheme.palette.base02};
      @define-color surface1 #${config.colorScheme.palette.base03};
      @define-color surface2 #${config.colorScheme.palette.base04};
      @define-color text #${config.colorScheme.palette.base05};
      @define-color rosewater #${config.colorScheme.palette.base06};
      @define-color lavender #${config.colorScheme.palette.base07};
      @define-color red #${config.colorScheme.palette.base08};
      @define-color peach #${config.colorScheme.palette.base09};
      @define-color yellow #${config.colorScheme.palette.base0A};
      @define-color green #${config.colorScheme.palette.base0B};
      @define-color teal #${config.colorScheme.palette.base0C};
      @define-color blue #${config.colorScheme.palette.base0D};
      @define-color mauve #${config.colorScheme.palette.base0E};
      @define-color flamingo #${config.colorScheme.palette.base0F};
    '';
 };
  
  fonts.fontconfig.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Ice";
    size = 26;
  };
}
