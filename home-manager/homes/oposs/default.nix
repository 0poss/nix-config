{
  lib,
  pkgs,
  inputs,
  config,
  overlays,
  homeConfFiles,
  ...
}:
{
  imports = with homeConfFiles.features; [
    inputs.nix-colors.homeManagerModules.default
    inputs.impermanence.nixosModules.home-manager.impermanence

    emacs
    fonts
    sway
    shell.zsh
    shell.eza
    apps.nyxt
  ];

  home = {
    stateVersion = lib.mkDefault "23.05";
    keyboard.layout = lib.mkDefault "us";
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
      binary-ninja
      nil # nix language server
      nixfmt-rfc-style # nix formatter
      texliveMedium
      pandoc
      python3
      sage
    ];
  };

  services.emacs.defaultEditor = config.services.emacs.enable;

  nixpkgs.overlays = (lib.attrValues overlays);

  fontProfiles = {
    enable = true;
    monospace = {
      family = "Berkeley Mono";
      package = pkgs.berkeley-mono.override {
        sha256 = "0f2237irx2a0ss325bgpzgxhvv5gz66j5xn2k3fnzb9pfzbjvvxf";
      };
    };
    regular = {
      family = "Iosevka Comfy Wide Motion Duo";
      package = pkgs.iosevka-comfy.comfy-wide-motion-duo;
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.bright;

  programs.git = {
    enable = true;
    userName = "0poss";
    userEmail = "brnnrlxndr@gmail.com";
  };

  home.persistence."/persist/home/oposs" = {
    allowOther = true;
    directories = [
      "Documents"
      "Pictures"
      ".emacs.d"
      #".config"
      ".local"
      ".gnupg"
      ".ssh"
    ];
  };
}
