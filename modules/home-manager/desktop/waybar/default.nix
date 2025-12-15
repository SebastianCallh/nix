{ ... }:
{
  programs.waybar = {
    enable = true;
    # colours are assumed to come from stylix or another style definition merged with this
    style = ''
    
      * {
        border: none;
        border-radius: 0;
      }
      
      #window {
        font-weight: bold;
      }
      
      #workspaces button {
        padding: 0 0.3em 0 0.3em;
        margin-top: 0.1em;
        margin-left: 0.1em;
      }

      #workspaces button.urgent {
        color: @base05;
        background: @base08;
      }      

      #language, #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode {
        padding: 0 0.5em 0 0.5em;
        margin-top: 0.1em;
        margin-bottom: 0.1em;
        margin-left: 0.1em;
        background-color: @base01;
      }
      
      @keyframes blink {
       to {
        background-color: @base08;
        color: @base05;
       }
      }
        
      #battery.warning:not(.charging) {
        color: @base05;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
    '';
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"]; 
        modules-right = ["tray" "hyprland/language" "battery" "clock"];
  
        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
  
        "hyprland/language" = {
          format = "{}";
          format-en = "󰌌  en";
          format-sv = "󰌌  se";
        };
  
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%d/%m}";
          tooltip = false;
        };
  
        battery = {
          bat = "BAT0";
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
    
          format = "{icon} {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-plugged = "  {capacity}%";
          format-discharging = "{icon}  {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["󰁻" "󰁼" "󰁾" "󰂀" "󰁹" ];
        };
          
        network = {
           format = "{ifname}";
           format-wifi = "  {essid}";
           format-ethernet = "{󰈁  ifname}";
           format-disconnected = "󰈂";
           tooltip-format-wifi = "{signalStrength}%";
           max-length = 20;  
        };
       
        # "custom/media": {
        #     "format": "{}",
        #     "interval": 1,
        #     "exec": "$HOME/.config/waybar/get_media.sh"
        # },
        # "custom/keyboard": {
        #     "format": " {}",
        #     "interval": 1,
        #     "exec": "$HOME/.config/waybar/get_kbdlayout.sh"
        # },
      };  
    };
  };
}

