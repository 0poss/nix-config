{ pkgs, nixosConfFiles, ... }:
{
  imports = with nixosConfFiles; [
    features.standard-disk-layout

    profiles.hardened

    users.oposs
    features.wayland
    features.nixpkgs
    features.wireless
    features.pipewire
    features.locale

    ./hardware-configuration.nix
    ./persist.nix
    ./secureboot.nix
  ];

  features.standard-disk-layout = {
    ephemeral-btrfs.enable = true;
    encryption.enable = true;
  };

  console.keyMap = "fr";
  home-manager = {
    users.oposs = {
      home.keyboard.layout = "fr";
    };
  };

  users.users.root.hashedPassword = "$6$rounds=50000000$cvIEZAR5IvtCciec$s2or9o8yAwnPO2gJmTE78Av3NJJRYXSsfBi1Rnf0IzU/0NsYENzDhBvszqWs2wZeEZ2qENawAMbjbbXVxvdwJ.";

  nix.settings.allowed-users = [ "@users" ];

  networking.hostName = "mini-newton";

  environment = with pkgs; {
    systemPackages = [
      git
      home-manager
      vim
      sbctl
    ];
  };

  security.chromiumSuidSandbox.enable = true;

  system.stateVersion = "23.05";
}
