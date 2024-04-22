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


      # I would like to @import url("./colors.css");
      # but I do not know from where `wofi --dmenu` runs
      # so I can't know the relative path. And I do not know how to
      # set an absolute path
      style = ''
        @define-color base #${config.colorScheme.palette.base00};
        @define-color mantle #${config.colorScheme.palette.base01};
        @define-color surface0 #${config.colorScheme.palette.base02};
        @define-color surface1 #${config.colorScheme.palette.base03};
        @define-color surface2 #${config.colorScheme.palette.base04};
        @define-color text #${config.colorScheme.palette.base05};
        @define-color rosewater #${config.colorScheme.palette.base06};
        @define-color lavender #${config.colorScheme.palette.base07};
        @define-color red #${config.colorScheme.palette.base08};
        @define-color peach #${config.colorScheme.palette.base09};
        @define-color yellow #${config.colorScheme.palette.base0A};
        @define-color green #${config.colorScheme.palette.base0B};
        @define-color teal #${config.colorScheme.palette.base0C};
        @define-color blue #${config.colorScheme.palette.base0D};
        @define-color mauve #${config.colorScheme.palette.base0E};
        @define-color flamingo #${config.colorScheme.palette.base0F};
           
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
            box-shadow: -4px -3px 45px 21px rgba(0,0,0,0.35);
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
