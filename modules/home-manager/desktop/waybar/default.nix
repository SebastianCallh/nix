{ config, ... }:
{
  programs.waybar = {
    enable = true;
    style = ''
      @import url("${config.styling.colors}/palette.css");
    
      * {
        border: none;
        border-radius: 0;
        font-size: 18px;
        font-family: Monoid Mono Nerd Font;
      }
      
      #window {
        font-weight: bold;
      }
      
      window#waybar {
        background: transparent;
        color: @text;
      }
      
      #workspaces button {
        padding: 0 0.5em 0 0.5em;
        border-radius: 10px;
        margin-top: 0.4em;
        margin-left: 0.4em;
        color: @teal;
        background: @surfac2;
      }
      
      #workspaces button.active {
        color: @mantle;
        background: @teal;
      }
      
      #workspaces button.focused {
        color: @text;
        background: @teal;
      } 
      
      #workspaces button.urgent {
        color: @mantle;
        background: @lavender;
      }
      
      #language, #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode {
        background: @mantle;
        padding: 0 0.5em 0 0.5em;
        border-radius: 10px;
        margin-top: 0.4em;
        margin-right: 0.4em;
      }
      
      @keyframes blink {
       to {
        background-color: @mantle;
        color: @text;
       }
      }
        
      #battery.warning:not(.charging) {
          color: @text;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }  '';
    
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

