{ config, ... }:
{
  flake.modules = {
    nixos.helix = {
      home-manager.sharedModules = [ config.flake.modules.homeManager.helix ];
    };

    homeManager.helix =
      { pkgs, ... }:
      {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        ruff
        pyright
        marksman
        vscode-json-languageserver
        lazygit
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
          # https://github.com/helix-editor/helix/discussions/12045
          # C-g = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw"];
        };
      };
  
      languages = {
        language-server.ruff = {
          command = "${pkgs.ruff}/bin/ruff";
          args = ["server"];
        };
    
        language = [
          {
            name = "python";
            auto-format = true;
            language-servers = [
              {
                name = "ruff";
                only-features = ["format" "diagnostics"];
              }
              { name = "pyright"; }
            ];
          }
        ];
      };
    };
      };
  };
}
