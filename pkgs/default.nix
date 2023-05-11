{ pkgs ? (import ../nixpkgs.nix) { } }: {
  ida-free = pkgs.callPackage ./ida-free { };
  libtriton = pkgs.callPackage ./triton { };
}
