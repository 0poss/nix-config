{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./git.nix
    ./pfetch.nix
  ];

  home.packages = with pkgs; [
    ripgrep # Better grep
    fd # Better find
  ];
}
