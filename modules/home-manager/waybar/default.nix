{ ... }:

{

programs.waybar = {
  enable = true;
  style = ./style.css;
  
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
        format-charging = "󰂄 {capacity}%";
        format-plugged = " {capacity}%";
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

