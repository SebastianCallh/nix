{ config, ... }:
let
  attach = {
    home-manager.sharedModules = [ config.flake.modules.homeManager.terminal ];
  };
in
{
  flake.modules = {
    nixos.terminal = attach;
    darwin.terminal = attach;

    # The contract. Each terminal lives in its own file next to this one and
    # registers itself below; nothing else in the config may name a terminal.
    homeManager.terminal =
      { config, lib, ... }:
      let
        cfg = config.terminal;
        chosen = cfg.terminals.${cfg.program};
      in
      {
        options.terminal = with lib; {
          terminals = mkOption {
            internal = true;
            default = { };
            description = ''
              Registry of the terminals this config knows how to run, one entry
              per sibling file. Everything a caller could want to know about a
              terminal other than its own settings lives here, so swapping
              terminal.program is the only edit a host ever needs.
            '';
            type = types.attrsOf (types.submodule {
              options = {
                package = mkOption {
                  type = types.package;
                  description = "The terminal itself.";
                };

                term = mkOption {
                  type = types.str;
                  description = ''
                    Name of the terminfo entry the terminal ships, which is not
                    the attribute name for any of them except foot.
                  '';
                };
              };
            });
          };

          program = mkOption {
            type = types.enum (builtins.attrNames cfg.terminals);
            description = "Which of the registered terminals this host runs.";
          };

          package = mkOption {
            readOnly = true;
            type = types.package;
            default = chosen.package;
          };

          font = mkOption {
            type = types.nullOr hm.types.fontType;
            default = null;
            description = ''
              Font for whichever terminal is selected, or null to leave the
              choice to stylix. Set it only on hosts that run without stylix,
              or to deliberately override it: each terminal translates this
              into its own spelling with mkForce.
            '';
          };

          multiplexer = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Command for a terminal multiplexer to launch the terminal into,
              or null for a bare terminal. Set by the multiplexer's own aspect
              rather than by hosts.

              A terminal that has splits or tabs of its own must give up those
              key binds while this is set, so that one set of keys tiles at one
              level only.
            '';
          };

          command = mkOption {
            readOnly = true;
            type = types.str;
            description = ''
              Command that opens a terminal. This is what the compositor should
              spawn, rather than the bare terminal binary: when a multiplexer is
              in play it wraps the terminal so the window comes up already
              attached to the persistent session.
            '';
            default =
              let terminal = lib.getExe cfg.package;
              in if cfg.multiplexer != null
                 # All three understand -e; foot and kitty only accept it for
                 # compatibility with xterm, but accept it they do.
                 then "${terminal} -e ${cfg.multiplexer}"
                 else terminal;
          };
        };

        config = {
          home.sessionVariables.TERM = chosen.term;

          # Terminals that take the font as a plain string cannot install the
          # package for us, so do it here for all of them.
          home.packages =
            lib.optional (cfg.font != null && cfg.font.package != null) cfg.font.package;
        };
      };
  };
}
