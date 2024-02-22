{config, pkgs, ...}:

{
  options = {};

  config = {
    programs.kitty = {
      enable = true;
      theme = "ayu_mirage";
    };
   };
}
