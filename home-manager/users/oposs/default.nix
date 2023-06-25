{ homeConfFiles, ... }:
{
  imports = with homeConfFiles; [
    users.base
    features.cli
    features.emacs
    features.desktop.wm.sway
    features.latex
  ];

  home.sessionVariables = {
    EDITOR = "emacs -nw";
  };
}
