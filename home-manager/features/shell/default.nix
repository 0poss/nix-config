{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "brackets" "cursor" "line" ];
    };
    localVariables = {
      PROMPT = "> ";
      RPROMPT = "%2~";
    };
  };
}
