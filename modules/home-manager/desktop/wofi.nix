{ config,  ... }:
let
  cfg = config.wofi;
in
{
  config = {
    programs.wofi = {
      enable = true;
      
      settings = {
        key_up = "Ctrl-p";
        key_down = "Ctrl-n";
      };

      style = ''
        window {
          border: 1px solid #${config.lib.stylix.colors.base0E};
        }

        #inner-box {
          margin: 5px;
          padding: 2px;
          border: none;
          border-radius: 0px;
        }
        
        #outer-box {
          margin: 5px;
          padding: 2px;
          border: none;
          border-radius: 0px;
        }
         
        #scroll {
          margin: 0px;
          border: none;
        }
         
        #input {
          border: none;
          border-radius: 0px;
        }
         
        #input image {
          border: none;
        }
         
        #text {
          margin: 5px;
          border: none;
        }

        #text:selected {
          color: #${config.lib.stylix.colors.base02};
        }

        #entry {
          padding: 0px;
          margin: 0px;
          border-radius: 0px;
          background-color: #${config.lib.stylix.colors.base01};
        }

        #entry:selected {
          background-color: #${config.lib.stylix.colors.base0E};
        }
      '';
    };
  };
}
