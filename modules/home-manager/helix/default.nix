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
        language-servers = ["pylsp"]
        auto-format = true
        
        [language.formatter]
        command = "black"
        args = ["--line-length", "88", "--quiet", "-"]
        
        [language-server.pylsp.config.pylsp]
        plugins.black.enabled = true
        plugins.pylint.enabled = true
        plugins.pyflakes.enabled = false
        plugins.pyls_mypy.enabled = true
        plugins.pyls_mypy.live_mode = false
        plugins.isort.enabled = true
        plugins.rope_autoimport.enabled = true
        
        [tool.black]
        line-length = 100

        [tool.pylint.format]
        max-line-length = 100
        
        [tool.isort]
        line_length = 100
        profile = "black"
      '';
    };
  };
}
