{ lib, ... }:

with lib;

{
  imports = [
    ./locale.nix
    ./zsh.nix
  ];

  nix.settings.allowed-users = mkDefault [ "@users" ];
}
