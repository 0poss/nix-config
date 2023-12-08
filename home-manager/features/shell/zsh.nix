{ homeConfFiles, ... }:
{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    shellAliases = import homeConfFiles.features.shell.aliases;
    localVariables = {
      PROMPT = "> ";
      RPROMPT = "%2~";
    };
  };
}
