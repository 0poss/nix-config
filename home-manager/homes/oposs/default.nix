{ lib, pkgs, inputs, config, overlays, homeConfFiles, ... }:
{
  imports = [
    homeConfFiles.features
  ];

  home = {
    username = "oposs";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      ripgrep
      fd
      fzf
      bat
      pfetch
    ];
  };

  nixpkgs.overlays = (lib.attrValues overlays);

  fontProfiles = {
    enable = true;
    monospace = {
      family = "Berkeley Mono";
      package = pkgs.berkeley-mono;
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.bright;

  programs.git = {
    enable = true;
    userName = "0poss";
    userEmail = "brnnrlxndr@gmail.com";
  };

  programs.home-manager.enable = true;

  emacs.enable = true;
  sway.enable = true;
}
