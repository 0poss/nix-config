{
  programs.zsh = {
    shellAliases = {
      l = "ls -lh";
      ll = "ls -lAh";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
}
