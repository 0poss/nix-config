{ config, homeConfFiles, ... }:
{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    sessionVariables = config.home.sessionVariables;
    shellAliases = import homeConfFiles.features.shell.aliases;
    localVariables = {
      PROMPT = "> ";
      RPROMPT = "%2~";
    };
  };
}
