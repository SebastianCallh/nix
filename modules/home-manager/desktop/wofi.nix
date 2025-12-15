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
          padding: 10px;
        }
        
        #outer-box {
          margin: 5px;
          padding: 10px;
          border: none;
        }
         
        #scroll {
          margin: 0px;
          padding: 10px;
          border: none;
        }
         
        #input {
          margin: 5px 20px;
          padding: 10px;
          border: none;
        }
         
        #input image {
          border: none;
        }
         
        #text {
          margin: 5px;
          border: none;
        }
      '';
    };
  };
}
