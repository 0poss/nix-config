{ inputs, outputs, ... }:
let
  inherit (outputs) homeModules;
in
{
  imports = with homeModules; [
    base
    features.cli
    features.emacs
    features.desktop.wm.sway
  ];
}
