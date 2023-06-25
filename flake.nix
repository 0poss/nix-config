{
  description = "0poss's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    rust-overlay.url = "github:oxalica/rust-overlay";

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      overlays = import ./overlays { inherit inputs; };

      nixosConfFiles = import ./nixos;
      homeConfFiles = import ./home-manager;

      mkHome = modules: pkgs: home-manager.lib.homeManagerConfiguration {
        inherit modules pkgs;
        extraSpecialArgs = { inherit inputs homeConfFiles overlays; };
      };
      mkNixOS = modules: nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = { inherit inputs nixosConfFiles overlays; };
      };
    in
    {
      inherit overlays;

      nixosConfigurations = {
        "nixos-teletubbies" = mkNixOS [ nixosConfFiles.hosts.teletubbies ];
        "nixos-mini-newton" = mkNixOS [ nixosConfFiles.hosts.mini-newton ];
      };

      homeConfigurations = {
        "home-oposs" = mkHome [ homeConfFiles.users.oposs ] nixpkgs.legacyPackages."x86_64-linux";
      };
    };
}
