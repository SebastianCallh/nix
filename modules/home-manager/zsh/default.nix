{config, pkgs, ...}:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ls = "exa";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
