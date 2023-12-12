{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  home.packages = with pkgs; [
    nil # nix language server
    nixpkgs-fmt # nix formatter
  ];

  home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/early-init.el".source = ./early-init.el;

  home.file.".emacs.d/config.org" = {
    source = ./config.org;
    onChange = "rm ~/.emacs.d/config.el || true";
  };
}
