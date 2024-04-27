{ pkgs, ... }:
{
  options.firefox = { };

  config = {
    programs.firefox = {
      enable = true;
      profiles = {
        seb = {
          id = 0;
          name = "seb";
          extraConfig = builtins.readFile ./prefs.js;

          # extraConfig = ''
          #   user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          # '';
      
          # userChrome = pkgs.fetchurl {
          #   url = "https://raw.githubusercontent.com/Tagggar/Firefox-Alpha/main/chrome/userChrome.css";
          #   sha256 = "he";
          # };
        
          # userContent = pkgs.fetchurl {
          #   url = "https://raw.githubusercontent.com/Tagggar/Firefox-Alpha/main/chrome/userContent.css";
          #   sha256 = "webaiwdh";
          # };
        };
      };
    };
  };
}
