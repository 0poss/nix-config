{ inputs, homeModules, ... }:
{
  imports = with homeModules; [
    base
    features.cli
    features.emacs
    features.desktop.wm.sway
  ];
}
