{config, pkgs, lib, ...}:

{
  options.helix = with lib; {
    theme = mkOption {
      type = types.str;
      default = "base16_default";
    };
  };

  config = {
    programs.helix.enable = true;
    home.file = {
      ".config/helix/config.toml".text = ''
        theme = "${config.helix.theme}"

        [editor]
        line-number = "relative"
        mouse = false

        [editor.cursor-shape]
        insert = "bar"
        normal = "block"
        select = "underline"

        [editor.indent-guides]
        render = true
        character = "┆"
      '';
    };
  };
}
