{ lib, pkgs, inputs, config, overlays, homeConfFiles, ... }:
{
  imports = with homeConfFiles.features; [
    inputs.nix-colors.homeManagerModules.default
    emacs
    fonts
    sway
    hyprland
    shell.zsh
    apps.nyxt
  ];

  home = {
    stateVersion = lib.mkDefault "23.05";
    keyboard.layout = lib.mkDefault "fr";
  };

  programs.home-manager.enable = true;
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

    sessionVariables = {
      EDITOR = "emacs";
    };
  };

  nixpkgs.overlays = (lib.attrValues overlays);

  fontProfiles = {
    enable = true;
    monospace = {
      family = "Berkeley Mono";
      package = pkgs.berkeley-mono.override {
        sha256 = "0f2237irx2a0ss325bgpzgxhvv5gz66j5xn2k3fnzb9pfzbjvvxf";
      };
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.bright;

  programs.git = {
    enable = true;
    userName = "0poss";
    userEmail = "brnnrlxndr@gmail.com";
  };
}
