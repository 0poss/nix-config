{ inputs, outputs, ... }:
{
  imports = [
    ./base
    ./features/cli
    ./features/desktop/sway.nix
  ];
}
