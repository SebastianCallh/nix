{ config, lib, ... }:
let
  cfg = config.zsh;
in
{
  options.zsh = with lib; {
    enable = mkEnableOption "enable";
  };
  
  config = {
    programs.zsh = {
      enable = cfg.enable;
      dotDir = ".config/zsh";
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      
      shellAliases = {
        ls = "exa";
        cd = "z";
        lg = "lazygit";
        lc = "lazydocker"; # 'l'azy'c'ontainers
        cat = "bat";
        ya = "yazi";
      };
  
      sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = 1;
      };
    };
  
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  
    programs.starship = {
      enable = true;
      settings = {
        package.disabled = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      
      aws = { symbol = "  "; };
      buf = { symbol = " "; };
      c = { symbol = " "; };
      conda = { symbol = " "; };
      crystal = { symbol = " "; };
      dart = { symbol = " "; };
      directory = { read_only = " 󰌾"; };
      docker_context = { symbol = " "; };
      elixir = { symbol = " "; };
      elm = { symbol = " "; };
      fennel = { symbol = " "; };
      fossil_branch = { symbol = " "; };
      git_branch = { symbol = " "; };
      golang = { symbol = " "; };
      gcloud = { symbol = " "; };
      guix_shell = { symbol = " "; };
      haskell = { symbol = " "; };
      haxe = { symbol = " "; };
      hg_branch = { symbol = " "; };
      hostname = { ssh_symbol = " "; };
      java = { symbol = " "; };
      julia = { symbol = " "; };
      kotlin = { symbol = " "; };
      lua = { symbol = " "; };
      memory_usage = { symbol = "󰍛 "; };
      meson = { symbol = "󰔷 "; };
      nim = { symbol = "󰆥 "; };
      nix_shell = { symbol = " "; };
      nodejs = { symbol = " "; };
      ocaml = { symbol = " "; };
      os.symbols = { Alpaquita = " "; };
      package = { symbol = "󰏗 "; };
      perl = { symbol = " "; };
      php = { symbol = " "; };
      pijul_channel = { symbol = " "; };
      python = { symbol = " "; };
      rlang = { symbol = "󰟔 "; };
      ruby = { symbol = " "; };
      rust = { symbol = " "; };
      scala = { symbol = " "; };
      swift = { symbol = " "; };
      zig = { symbol = " "; };
      };
    };
  
    programs.bat = {
      enable = true;
    };
  
    programs.eza = {
      enable = true;
    };
  };
}
