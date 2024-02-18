{config, pkgs, lib, ...}

{
  options = with lib; {
    theme = {
      type = types.str;
      default = "base16_default";
    }
  };

  config = {
    
    home.file = {
      ".config/helix/config.toml".text = ''
        theme = ${options.theme};
      ''
    };
  };
}
