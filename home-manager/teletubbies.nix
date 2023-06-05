{ inputs, outputs, ... }:
{
  imports = [
    ./base
    ./features/cli
    ./features/emacs
    ./features/desktop/wm/sway.nix
  ];
}
