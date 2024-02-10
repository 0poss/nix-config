{
  description = "0poss's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-colors.url = "github:misterio77/nix-colors";
    rust-overlay.url = "github:oxalica/rust-overlay";
    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

      devShells = forAllSystems (system: import ./dev-shells {
        pkgs = nixpkgs.legacyPackages.${system};
      });

      packages = forAllSystems (system: import ./pkgs {
        pkgs = nixpkgs.legacyPackages.${system};
      });

      nixosConfigurations = {
        "nixos-teletubbies" = mkNixOS [ nixosConfFiles.hosts.teletubbies ];
        "nixos-mini-newton" = mkNixOS [ nixosConfFiles.hosts.mini-newton ];
        "nixos-baby-quine" = mkNixOS [ nixosConfFiles.hosts.baby-quine ];
        "nixos-puffy" = mkNixOS [ nixosConfFiles.hosts.puffy ];
      };

      homeConfigurations = {
        "home-oposs" = mkHome
          [ homeConfFiles.homes.oposs ]
          nixpkgs.legacyPackages."x86_64-linux";
      };
    };
}
