{
  description = "0poss's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

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
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];

      overlays = import ./overlays { inherit inputs; };

      nixosConfFiles = import ./nixos;
      homeConfFiles = import ./home-manager;

      mkHome = modules: pkgs: home-manager.lib.homeManagerConfiguration {
        inherit modules pkgs;
        extraSpecialArgs = { inherit inputs homeConfFiles overlays; };
      };
      mkNixOS = modules: nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = { inherit inputs nixosConfFiles homeConfFiles overlays; };
      };
    in
    {
      inherit overlays;

      packages = forAllSystems (system: import ./pkgs {
        pkgs = nixpkgs.legacyPackages.${system};
      });

      nixosConfigurations = {
        "nixos-teletubbies" = mkNixOS [ nixosConfFiles.hosts.teletubbies ];
        "nixos-mini-newton" = mkNixOS [ nixosConfFiles.hosts.mini-newton ];
        "nixos-puffy" = mkNixOS [ nixosConfFiles.hosts.puffy ];
      };

      homeConfigurations = {
        "home-oposs" = mkHome [ homeConfFiles.homes.oposs ] nixpkgs.legacyPackages."x86_64-linux";
      };
    };
}
