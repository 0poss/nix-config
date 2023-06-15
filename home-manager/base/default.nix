{ inputs, pkgs, lib, config, overlays, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../features/cli
  ] ++ (builtins.attrValues (import ../options));

  # Configure nixpkgs.
  nixpkgs = {
    overlays = lib.attrValues overlays;
    config.allowUnfree = false;
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    vim.enable = true;
    helix.enable = true;
  };

  # Default home-manager configuration.
  home = {
    username = lib.mkDefault "oposs";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";

    keyboard.layout = lib.mkDefault "fr";
  };

  # Setup default colors.
  colorscheme = lib.mkDefault colorSchemes.bright;
}
