{ pkgs, lib, inputs, nixosModules, overlays, ... }:
{
  imports = [
    nixosModules.base
    nixosModules.users.oposs
    nixosModules.features.nixpkgs
    nixosModules.features.wayland
    nixosModules.features.nixpkgs
    nixosModules.features.wireless

    ./hardware-configuration.nix
    ./ephemeral-btrfs.nix
    ./persist.nix
  ];

  networking.hostName = "teletubbies";

  environment = with pkgs; {
    systemPackages = [ emacs ];
    shells = [ bash zsh ];
  };

  security.chromiumSuidSandbox.enable = true;

  programs.firejail.enable = true;

  programs.firejail.wrappedBinaries = {
    firefox = {
      executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    };
    chromium = {
      executable = "${pkgs.lib.getBin pkgs.chromium}/bin/chromium";
      profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
    };
  };

  system.stateVersion = "23.05";
}
