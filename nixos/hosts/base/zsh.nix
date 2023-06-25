{
  programs.zsh = {
    enable = true;
    shellAliases = {
      l = "ls -lh";
      ll = "ls -lAh";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
}
