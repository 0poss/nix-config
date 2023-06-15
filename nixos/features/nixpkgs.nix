{ lib, inputs, config, overlays, ... }:
{
  nixpkgs = {
    overlays = lib.attrValues overlays;
    config = {
      allowUnfree = false;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };


}
