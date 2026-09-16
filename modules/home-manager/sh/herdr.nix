{ config, lib, pkgs, ... }:
let
  cfg = config.herdr;

  # Stylix has no herdr target, so the palette is mapped by hand. herdr only
  # exposes these ten tokens (struct ModeThemeColors in the 0.9 binary);
  # everything else it draws comes from the host terminal, which stylix
  # already themes via the ghostty/kitty targets. That is also why the base
  # theme is "terminal" rather than one of the bundled ones.
  c = config.lib.stylix.colors.withHashtag;

  # Empty means "use $SHELL", which is the right fallback when zsh is off.
  defaultShell =
    if config.programs.zsh.enable then lib.getExe config.programs.zsh.package else "";
in
{
  options.herdr = with lib; {
    enable = mkEnableOption "herdr, an agent-aware terminal multiplexer";

    prefix = mkOption {
      type = types.str;
      default = "ctrl+space";
      description = ''
        Key that opens herdr's prefix mode. Deliberately not the ctrl+b
        default, which is page-up in helix, nor ctrl+a, which is
        beginning-of-line in zsh.
      '';
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Launch the terminal directly into herdr, so that every terminal
        window opened from the compositor attaches to the persistent
        session. Consumed by the readOnly sh.command option.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.herdr = {
      enable = true;

      settings = {
        onboarding = false;

        # The package comes from nixpkgs and the store is read only, so the
        # self-updater can never do anything except nag. The agent-detection
        # manifest check is left on, since that one is a real feature.
        update.version_check = false;

        terminal = {
          default_shell = defaultShell;
          new_cwd = "follow";
        };

        theme = {
          name = "terminal";
          # stylix decides light vs dark; herdr must not second-guess it by
          # sniffing the terminal's reported appearance.
          auto_switch = false;
          custom = {
            accent = c.base0D;
            # base01 < base02 < base03 keeps the sidebar, the focused row and
            # the picker selection visually distinct.
            sidebar_bg = c.base01;
            active_row_bg = c.base02;
            selection_bg = c.base03;
            surface_dim = c.base00;
            red = c.base08;
            peach = c.base09;
            yellow = c.base0A;
            green = c.base0B;
            mauve = c.base0E;
          };
        };

        ui = {
          accent = c.base0D;
          sidebar_width = 28;
        };

        keys = {
          prefix = cfg.prefix;

          # Direct bindings, no prefix. These are exactly the keys ghostty
          # used to bind to its own splits and tabs, so the muscle memory
          # carries over unchanged; they are simply routed to herdr now.
          focus_pane_left = "ctrl+h";
          focus_pane_down = "ctrl+j";
          focus_pane_up = "ctrl+k";
          focus_pane_right = "ctrl+l";
          previous_tab = "alt+h";
          next_tab = "alt+l";
          move_tab_previous = "alt+shift+h";
          move_tab_next = "alt+shift+l";

          # Moving tab navigation off the prefix frees prefix+n and prefix+p
          # for hopping between agents, which is the reason to run herdr at all.
          next_agent = "prefix+n";
          previous_agent = "prefix+p";
          focus_agent = "prefix+alt+1..9";

          # Mirrors hyprland's "$mod shift + direction moves the window".
          swap_pane_left = "prefix+shift+h";
          swap_pane_down = "prefix+shift+j";
          swap_pane_up = "prefix+shift+k";
          swap_pane_right = "prefix+shift+l";

          split_vertical = "prefix+v";
          split_horizontal = "prefix+minus";
          zoom = "prefix+z";
          resize_mode = "prefix+r";
          close_pane = "prefix+x";

          new_tab = "prefix+c";
          close_tab = "prefix+shift+x";
          switch_tab = "prefix+1..9";

          new_workspace = "prefix+shift+n";
          workspace_picker = "prefix+w";

          toggle_sidebar = "prefix+b";
          detach = "prefix+d";
          reload_config = "prefix+shift+r";
        };
      };
    };
  };
}
