{ pkgs, lib, nixosConfFiles, ... }:
{
  imports = with nixosConfFiles; [
    features.standard-disk-layout

    #profiles.hardened

    users.oposs
    features.wayland
    features.nixpkgs
    features.wireless
    features.locale

    ./hardware-configuration.nix
    ./persist.nix
  ];

  features.standard-disk-layout = {
    ephemeral-btrfs.enable = true;
    encryption.enable = true;
  };

  console.keyMap = "us";

  home-manager = {
    users.oposs =
      {
        home.keyboard.layout = "us";
        fontProfiles.monospace = lib.mkForce
          {
            family = "Iosevka Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; };
          };
      };
  };

  users.users.root.hashedPassword = "$6$rounds=50000000$cvIEZAR5IvtCciec$s2or9o8yAwnPO2gJmTE78Av3NJJRYXSsfBi1Rnf0IzU/0NsYENzDhBvszqWs2wZeEZ2qENawAMbjbbXVxvdwJ.";

  nix.settings.allowed-users = [ "@users" ];

  networking.hostName = "teletubbies";

  environment = with pkgs; {
    systemPackages = [ git home-manager vim ];
  };

  security.chromiumSuidSandbox.enable = true;

  system.stateVersion = "23.05";
}
