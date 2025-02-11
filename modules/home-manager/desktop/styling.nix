{ pkgs, config, inputs, lib, ... }: 
let
  cfg = config.styling;
in
{
  options.styling = with lib; {
    fontName = mkOption {
      readOnly = true;
      type = types.str;

      # after nix version 25 something all nerd fonts were moved
      # to separate packages and for when using them fonts are installed in a different 
      # place (I think) which causes kitty to crash which  makes it so I can't do anything
      # default = "Hack Nerd Font Mono";
      default = "Consolas";
    };
    
    theme = mkOption {
      type = types.enum [ "light" "dark" ];  
    };
    
    colors = mkOption {
      readOnly = true;
      default = pkgs.writeTextFile {
        name = "colors";
        destination = "/palette.css";
        text = let
          p = config.styling.colorScheme.palette;
        in ''
          @define-color base #${p.base00};
          @define-color mantle #${p.base01};
          @define-color surface0 #${p.base02};
          @define-color surface1 #${p.base03};
          @define-color surface2 #${p.base04};
          @define-color text #${p.base05};
          @define-color rosewater #${p.base06};
          @define-color lavender #${p.base07};
          @define-color red #${p.base08};
          @define-color peach #${p.base09};
          @define-color yellow #${p.base0A};
          @define-color green #${p.base0B};
          @define-color teal #${p.base0C};
          @define-color blue #${p.base0D};
          @define-color mauve #${p.base0E};
          @define-color flamingo #${p.base0F};
        '';
      };
    };

    colorScheme = mkOption {
      readOnly = true;
      default = {
        "light" = inputs.nix-colors.colorSchemes.catppuccin-latte;
        "dark" = inputs.nix-colors.colorSchemes.catppuccin-frappe;
      }."${cfg.theme}";
    };

    wallpaper = mkOption {
      readOnly = true;
      type = types.path;
      default = {
        "light" = ../../../images/nix-catppuccin-latte.png;
        "dark" = ../../../images/nix-catppuccin-frappe.png;
      }."${cfg.theme}";
    };
  };
  
  config = {
    catppuccin.flavor = {
      "light" = "latte";
      "dark" = "frappe";
    }."${cfg.theme}";

    # we can use the API of catppuccin/nix to style 
    # things that does not have their own CSS
    catppuccin = {
      starship.enable = true;
      helix.enable = true;
      kitty.enable = true;
      yazi.enable = true;
      bat.enable = true;
      fzf.enable = true;
      zellij.enable = true;
      delta.enable = true;
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
