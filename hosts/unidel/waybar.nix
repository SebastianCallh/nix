{ config, pkgs, builtins, ... }:

{

programs.waybar = {
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = ["hyprland/workspaces"]; 
      modules-right = ["network" "battery" "clock"];
      
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
          critical = 10;
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
  
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-size: 20px;
          font-family: "Monoid Mono Nerd Font:size=11";
          all: unset;
        }
   
        window#waybar {
          background: #${config.colorScheme.palette.base01};
          color: #${config.colorScheme.palette.base05};
        } 
        
        #workspaces button {
          padding: 0 5px;
        }

        #workspaces button.active { 
          background: #${config.colorScheme.palette.base0C};
          color: #${config.colorScheme.palette.base04};
        }

        #workspaces button.focused {
          color: #ffffff;
          background: #eba0ac;
          border-radius: 10px;
        }
        
        #workspaces button.urgent {
          color: #11111b;
          background: #a6e3a1;
          border-radius: 10px;
        }
         
        #battery { 
          background: #${config.colorScheme.palette.base08};
          color: #${config.colorScheme.palette.base04};
        }
      '';
    };
  };
};

}
