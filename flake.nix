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
      inherit (self) outputs;

      forEachSystem = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];

      mkHome = modules: pkgs: home-manager.lib.homeManagerConfiguration {
        inherit modules pkgs;
        extraSpecialArgs = { inherit inputs outputs; };
      };
    in
      rec {
        overlays = import ./overlays { inherit inputs; };

        nixosConfigurations = {
          teletubbies = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs overlays; };
            modules = [ ./nixos/hosts/teletubbies ];
          };
        };

        homeConfigurations = {
          "oposs@teletubbies" = mkHome [ ./home-manager/teletubbies.nix ] nixpkgs.legacyPackages."x86_64-linux";
        };
      };
}
