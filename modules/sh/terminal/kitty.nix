{ ... }:
{
  flake.modules.homeManager.terminal =
    { config, lib, pkgs, ... }:
    let
      cfg = config.terminal;

      # vanilla kitty commands, the counterpart to ghostty's list: everything
      # kitty binds under kitty_mod (ctrl+shift) to manage its own windows and
      # tabs. Handed back to the multiplexer when one is running. Making a new
      # OS window is deliberately left alone, since that is the compositor's
      # business rather than the multiplexer's.
      tiling =
        map (n: "ctrl+shift+${toString n}") (lib.range 0 9)  # first..tenth_window
        ++ [
          "ctrl+shift+enter"              # new_window
          "ctrl+shift+w"                  # close_window
          "ctrl+shift+]"                  # next_window
          "ctrl+shift+["                  # previous_window
          "ctrl+shift+f"                  # move_window_forward
          "ctrl+shift+b"                  # move_window_backward
          "ctrl+shift+`"                  # move_window_to_top
          "ctrl+shift+r"                  # start_resizing_window
          "ctrl+shift+f7"                 # focus_visible_window
          "ctrl+shift+f8"                 # swap_with_window
          "ctrl+shift+l"                  # next_layout
          "ctrl+shift+t"                  # new_tab
          "ctrl+shift+q"                  # close_tab
          "ctrl+shift+alt+t"              # set_tab_title
          "ctrl+shift+."                  # move_tab_forward
          "ctrl+shift+,"                  # move_tab_backward
          "ctrl+tab"                      # next_tab
          "ctrl+shift+tab"                # previous_tab
          "ctrl+shift+right"              # next_tab
          "ctrl+shift+left"               # previous_tab
        ];

      ownTiling = {
        # navigate splits
        "ctrl+h" = "neighboring_window left";
        "ctrl+l" = "neighboring_window right";
        "ctrl+j" = "neighboring_window bottom";
        "ctrl+k" = "neighboring_window top";

        #navigate tabs
        "alt+h" = "previous_tab";
        "alt+l" = "next_tab";

        # move tabs
        "alt+shift+h" = "move_tab_backward";
        "alt+shift+l" = "move_tab_forward";
      };
    in
    {
      config = {
        terminal.terminals.kitty = {
          package = pkgs.kitty;
          term = "xterm-kitty";
        };

        programs.kitty = lib.mkIf (cfg.program == "kitty") {
          enable = true;
          shellIntegration.enableZshIntegration = config.programs.zsh.enable;

          font = lib.mkIf (cfg.font != null) (lib.mkForce cfg.font);

          keybindings =
            (if cfg.multiplexer != null
             then lib.genAttrs tiling (_: "no_op")
             else ownTiling)
            // {
              # handle line breaks, as for ghostty
              "ctrl+enter" = "send_text all \\r";
            };
        };
      };
    };
}
