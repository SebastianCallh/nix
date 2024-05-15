{ config, lib, ... }:
let
  cfg = config.wofi;
in
{
  options.wofi = with lib; {
    font = mkOption {
      type = hm.types.fontType;
      default = {
        name = "consolas";
        size = 10;
      };
    };
  };
  
  config = {
    programs.wofi = {
      enable = true;
      
      settings = {
        key_up = "Ctrl-p";
        key_down = "Ctrl-n";
      };

      style = ''
        @import url("${config.styling.colors}/palette.css");

        *{
            font-family: "${cfg.font.name}";
            font-size: ${toString cfg.font.size}px;
        }
         
        window {
            border: 2px solid @teal;
            border-radius: 20px;
        }
         
        #input {
            margin-bottom: 15px;
            padding: 3px;
            border-radius: 5px;
            border: none;
            color: @blue;
        }
         
        #inner-box {
            background-color: @mantle;
        }
         
        #outer-box {
            margin: 5px;
            padding: 10px;
            background-color: @base;
            border-radius: 15px;
        }
         
        #text {
            padding: 5px;
            color: @blue;
        }
         
        #entry {
            padding: 10px;
        }
         
         
        #entry:selected {
            color: @rosewater;
            font-weight: bold;
        }
    '';
    };
  };
}
