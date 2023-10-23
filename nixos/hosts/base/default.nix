{ lib, ... }:

with lib;

{
  imports = [
    ./locale.nix
    ./zsh.nix
  ];

  security.pam.services.swaylock = {};

  users.users.root.hashedPassword = "$6$rounds=50000000$cvIEZAR5IvtCciec$s2or9o8yAwnPO2gJmTE78Av3NJJRYXSsfBi1Rnf0IzU/0NsYENzDhBvszqWs2wZeEZ2qENawAMbjbbXVxvdwJ.";

  nix.settings.allowed-users = mkDefault [ "@users" ];

  environment = {
    memoryAllocator.provider = mkDefault "graphene-hardened";
  };
}
