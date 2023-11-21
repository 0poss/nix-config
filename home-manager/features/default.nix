{ lib, inputs, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default

    ./desktop
    ./emacs
    ./shell
    ./fonts.nix
  ];

  home = {
    stateVersion = lib.mkDefault "23.05";
    keyboard.layout = lib.mkDefault "fr";
  };
}
