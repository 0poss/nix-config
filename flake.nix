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
          "oposs@teletubbies" = mkHome [ ./home-manager/hosts/teletubbies ] nixpkgs.legacyPackages."x86_64-linux";
        };

        homeModules = {
          base = import ./home-manager/base;
          features = {
            cli = import ./home-manager/features/cli;
            desktop = {
              base = import ./home-manager/features/desktop/base;
              apps = {
                chromium = import ./home-manager/features/desktop/apps/chromium.nix;
                i3status-rust = import ./home-manager/features/desktop/apps/i3status-rust.nix;
                kickoff = import ./home-manager/features/desktop/apps/kickoff.nix;
                kitty = import ./home-manager/features/desktop/apps/kitty.nix;
              };
              wm = {
                sway = import ./home-manager/features/desktop/wm/sway;
              };
            };
            emacs = import ./home-manager/features/emacs;
          };
        };
      };
}
