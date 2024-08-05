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

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    programs.helix = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      extraPackages = with pkgs; [
        lazygit
        black
        isort
        pyright
      ];
    
      settings = {
        editor = {
          line-number = "relative";
          mouse = false;
        };
        
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        
        editor.indent-guides = {
          render = true;
          character = "┆";
        };
        
        keys.normal = {
          C-g = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw"];
        };
      };
    };
    
    home.file = {
      ".config/helix/languages.toml".text = 
      let 
        ll = toString 89;
      in '' 
        [[language]]
        name = "python"
        language-servers = ["pyright"]
        auto-format = true
        roots = ["setup.py", "setup.cfg", "pyproject.toml", "requirements.txt"]
        formatter = { command = "sh", args = ["-c", "black --quiet - | isort -"] }

        [tool.black]
        line-length = ${ll}

        [tool.pylint.format]
        max-line-length = ${ll}
        
        [tool.isort]
        line_length = ${ll}
        profile = "black"
      '';
    };
  };
}
