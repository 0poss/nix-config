{ pkgs, nixosConfFiles, ... }:
{
  imports = [
    nixosConfFiles.hosts.base
    nixosConfFiles.users.oposs
    nixosConfFiles.features.nixpkgs
    nixosConfFiles.features.pipewire
    nixosConfFiles.features.wayland
    nixosConfFiles.features.wireless
    nixosConfFiles.profiles.hardened

    ./hardware-configuration.nix
    ./disk.nix
  ];

  networking.hostName = "mini-newton";

  environment = with pkgs; {
    systemPackages = [ vim ];
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
