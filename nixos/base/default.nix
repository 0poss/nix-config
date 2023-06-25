{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ./locale.nix
    ./zsh.nix
  ];

  nix.settings.allowed-users = mkDefault [ "@users" ];

  # I didn't notice any error coming from using scudo so that's free hardening.
  # OK actually there ARE some errors (for example when building the configuration) such as :
  # version `GLIBC_ABI_DT_RELR' not found
  # and similar errors.
  environment.memoryAllocator.provider = mkDefault "scudo";
  environment.variables.SCUDO_OPTIONS = mkDefault "zero_contents=1";
}
