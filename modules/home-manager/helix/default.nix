{config, lib, ...}:

{
  options.helix = with lib; {
    theme = mkOption {
      type = types.str;
      default = "base16_transparent";
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

    home.file = {
      ".config/helix/languages.toml".text = '' 

        [[language]]
        name = "python"
        language-servers = ["pyright"]
        auto-format = true
        roots = ["setup.py", "setup.cfg", "pyproject.toml"]
        formatter = { command = "black", args = ["--quiet", "--line-length", "88", "-"] }

        [tool.black]
        line-length = 88

        [tool.pylint.format]
        max-line-length = 88
        
        [tool.isort]
        line_length = 88
        profile = "black"
      '';
    };
  };
}
