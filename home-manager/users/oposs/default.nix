{ homeModules, pkgs, ... }:
{
  imports = with homeModules; [
    base
    features.cli
    features.emacs
    features.desktop.wm.sway
    features.latex
  ];

  home.sessionVariables = {
    EDITOR = "emacs -nw";
  };
}
