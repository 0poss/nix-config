{ homeConfFiles, ... }:
{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    shellAliases = homeConfFiles.features.shell.aliases;
    localVariables = {
      PROMPT = "> ";
      RPROMPT = "%2~";
    };
  };
}
