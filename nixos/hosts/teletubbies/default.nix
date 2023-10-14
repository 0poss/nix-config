{ pkgs, nixosConfFiles, ... }:
{
  imports = with nixosConfFiles; [
    hosts.base
    profiles.hardened

    users.oposs
    features.nixpkgs
    features.wayland
    features.nixpkgs
    features.wireless
    #features.virtualization

    ./hardware-configuration.nix
    ./ephemeral-btrfs.nix
    ./persist.nix
  ];

  networking.hostName = "teletubbies";

  environment = with pkgs; {
    systemPackages = [ git emacs ];
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
