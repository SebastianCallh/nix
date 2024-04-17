{config, lib, pkgs, ...}:
let 
cfg = config.helix;
in
{
  options.helix = with lib; {
    theme = mkOption {
      type = types.str;
      default = "base16_transparent";
    };

    git_tui = mkOption {
      type = types.str;
    };
  };

  config = {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [
        python3Packages.black
        nodePackages.pyright
      ];
    };
    
    home.file = {
      ".config/helix/config.toml".text = ''
        theme = "${cfg.theme}"

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

        [keys.normal]
        C-g = [":new", ":insert-output ${cfg.git_tui}", ":buffer-close!", ":redraw"]
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
