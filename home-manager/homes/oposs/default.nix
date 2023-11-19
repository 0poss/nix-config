{ pkgs, homeConfFiles, ... }:
{
  imports = with homeConfFiles; [
    homes.base
    features.cli
    features.emacs
    features.desktop.wm.sway
    features.latex
  ];

  fontProfiles = {
    enable = true;
    monospace = {
      family = "Berkeley Mono";
      package = pkgs.berkeley-mono;
    };
  };

  home.sessionVariables = {
    EDITOR = "emacs -nw";
  };
}
