{ lib, ... }:

with lib;

{
  imports = [
    ./locale.nix
    ./zsh.nix
  ];

  nix.settings.allowed-users = mkDefault [ "@users" ];

  # I didn't notice any error coming from using scudo so that's free hardening.
  environment.memoryAllocator.provider = mkDefault "scudo";
  environment.variables.SCUDO_OPTIONS = mkDefault "zero_contents=1";
}
