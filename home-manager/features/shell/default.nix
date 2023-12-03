{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    localVariables = {
      PROMPT = "> ";
      RPROMPT = "%2~";
    };
  };
}
