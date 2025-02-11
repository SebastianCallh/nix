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
        ruff
        pyright
      ];
    
      settings = {
        editor = {
          line-number = "relative";
          mouse = false;
          soft-wrap.enable = true;

          # try out the new experimental inline diagnostics
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "error";
          };
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
          # for some reason Esc does not work in this view, so you can't cancel commits. Awkward!
          # C-g = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw"];
        };
      };
    };
    
    home.file = {
      ".config/helix/languages.toml".text = 
      '' 
        [language-server.ruff]
        command = "${pkgs.ruff}/bin/ruff"
        args = ["server"]

        [[language]]
        name = "python"
        auto-format = true
        language-servers = [
          { name = "ruff", only-features = [ "format", "diagnostics" ] },
          { name = "pyright" },
        ]
      '';
    };
  };
}
