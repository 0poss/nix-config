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

  outputs = { self, nixpkgs, home-manager, nix-colors, rust-overlay, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];
    in
      rec {
        overlays = import ./overlays { inherit inputs; };

        packages = forAllSystems (system:
          let overlays = [ (import rust-overlay) ];
              pkgs = import nixpkgs { inherit system overlays; };
          in import ./pkgs { inherit pkgs; }
        );

        devShells = forAllSystems (system:
          let overlays = [ (import rust-overlay) ];
              pkgs = import nixpkgs { inherit system overlays; };
          in import ./shell.nix { inherit pkgs; }
        );

        nixosConfigurations = {
          teletubbies = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs overlays; };
            modules = [ ./nixos/configuration.nix ];
          };
        };

        homeConfigurations = {
          "oposs@teletubbies" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            extraSpecialArgs = { inherit nix-colors overlays; };
            modules = [ ./home-manager/home.nix ];
          };
        };
      };
}
