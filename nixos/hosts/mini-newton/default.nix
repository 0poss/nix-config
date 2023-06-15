{ pkgs, lib, inputs, nixosModules, overlays, ... }:
{
  imports = [
    nixosModules.base
    nixosModules.users.oposs
    nixosModules.features.nixpkgs
    nixosModules.features.pipewire
    nixosModules.features.wayland
    nixosModules.features.wireless
    nixosModules.kernels.hardened

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

  system.stateVersion = "22.11"; # Did you read the comment?
}
