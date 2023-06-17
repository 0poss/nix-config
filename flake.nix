{
  description = "0poss's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      overlays = import ./overlays { inherit inputs; };

      overlayedPkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = builtins.attrValues overlays;
      };

      nixosModules = import ./nixos;
      homeModules = import ./home-manager;
      mkHome = modules: pkgs: home-manager.lib.homeManagerConfiguration {
        inherit modules pkgs;
        extraSpecialArgs = { inherit inputs homeModules overlays; };
      };
      mkNixOS = modules: nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = { inherit inputs nixosModules overlays; };
      };
    in
    {
      inherit overlays;

      nixosConfigurations = {
        teletubbies = mkNixOS [ nixosModules.hosts.teletubbies ];
        mini-newton = mkNixOS [ nixosModules.hosts.mini-newton ];
      };

      homeConfigurations = {
        "oposs" = mkHome [ homeModules.users.oposs ] nixpkgs.legacyPackages."x86_64-linux";
      };
    };
}
