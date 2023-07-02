{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./git.nix
    ./pfetch.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    ripgrep # Better grep
    fd # Better find
    fzf # Fuzzy finder
  ];
}
