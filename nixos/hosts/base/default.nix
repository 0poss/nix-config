{ lib, inputs, overlays, homeConfFiles, ... }:

with lib;

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./locale.nix
    ./zsh.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs homeConfFiles overlays; };
    users.oposs = homeConfFiles.homes.oposs;
  };

  users.users.root.hashedPassword = "$6$rounds=50000000$cvIEZAR5IvtCciec$s2or9o8yAwnPO2gJmTE78Av3NJJRYXSsfBi1Rnf0IzU/0NsYENzDhBvszqWs2wZeEZ2qENawAMbjbbXVxvdwJ.";

  nix.settings.allowed-users = mkDefault [ "@users" ];

  # I didn't notice any error coming from using scudo so that's free hardening.
  # OK actually there ARE some errors (for example when building the configuration) such as :
  # version `GLIBC_ABI_DT_RELR' not found
  # and similar errors.
  # UPDATE : it's actually making nix crash when rebuilding the OS configuration on teletubbies. Not cool.
  #          I will maybe investing later.
  #environment.memoryAllocator.provider = mkDefault "scudo";
  #environment.variables.SCUDO_OPTIONS = mkDefault "zero_contents=1";
}
