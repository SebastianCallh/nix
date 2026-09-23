{ ... }:
{
  flake.modules.homeManager.terminal =
    { config, lib, pkgs, ... }:
    let
      cfg = config.terminal;
    in
    {
      config = {
        terminal.terminals.foot = {
          package = pkgs.foot;
          term = "foot";
        };

        programs.foot = lib.mkIf (cfg.program == "foot") {
          enable = true;

          settings = {
            main = {
              pad = "15x10";
              font = lib.mkIf (cfg.font != null) (lib.mkForce (
                "${cfg.font.name}"
                + lib.optionalString (cfg.font.size != null) ":size=${toString cfg.font.size}"
              ));
            };

            mouse.hide-when-typing = "yes";

            # foot has neither splits nor tabs, so unlike ghostty and kitty it
            # has nothing to hand back when a multiplexer is running: every key
            # the multiplexer wants is already free.
            text-bindings = {
              # handle line breaks, as for ghostty
              "\\x0d" = "Control+Return";
            };
          };
        };
      };
    };
}
