{ config, lib, ... }:
let
  
  # vanilla ghostty commands
  # We use them explicitly here so we can disable them in favour for a terminal multiplexer
  ghosttyTiling =
    map (n: "alt+${toString n}") (lib.range 1 8)
    ++ map (n: "alt+digit_${toString n}") (lib.range 1 8)
    ++ [
      "ctrl+shift+o"                  # new_split:right
      "ctrl+shift+e"                  # new_split:down
      "ctrl+shift+enter"              # toggle_split_zoom
      "ctrl+alt+arrow_up"             # goto_split:*
      "ctrl+alt+arrow_down"
      "ctrl+alt+arrow_left"
      "ctrl+alt+arrow_right"
      "super+ctrl+["                  # goto_split:previous
      "super+ctrl+]"                  # goto_split:next
      "super+ctrl+shift+arrow_up"     # resize_split:*
      "super+ctrl+shift+arrow_down"
      "super+ctrl+shift+arrow_left"
      "super+ctrl+shift+arrow_right"
      "ctrl+shift+t"                  # new_tab
      "ctrl+shift+w"                  # close_tab:this
      "ctrl+tab"                      # next_tab
      "ctrl+shift+tab"                # previous_tab
      "ctrl+page_down"                # next_tab
      "ctrl+page_up"                  # previous_tab
      "ctrl+shift+arrow_right"        # next_tab
      "ctrl+shift+arrow_left"         # previous_tab
    ];

  ghosttyOwnTiling = [
    # navigate splits
    "ctrl+h=goto_split:left"
    "ctrl+l=goto_split:right"
    "ctrl+j=goto_split:bottom"
    "ctrl+k=goto_split:top"

    #navigate tabs
    "alt+h=previous_tab"
    "alt+l=next_tab"

    # move tabs
    "alt+shift+h=move_tab:-1"
    "alt+shift+l=move_tab:1"
  ];
in
{
  config = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      settings = {
        gtk-tabs-location = "top";
        window-decoration = false;
        keybind =
          (if config.herdr.enable
           then map (k: "${k}=unbind") ghosttyTiling
           else ghosttyOwnTiling)
          ++ [
            # handle line breaks
            # https://github.com/ghostty-org/ghostty/discussions/3151#discussioncomment-11678064
            "ctrl+enter=text:\r"
          ];
      };
    };
  };
}
