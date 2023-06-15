{ pkgs, config, ... }:
{
  programs.emacs = {
    enable = true;
  };

  home.packages = with pkgs; [
    nil # nix language server
    nixpkgs-fmt # nix formatter
  ];

  home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/config.org".source = ./config.org;
}
