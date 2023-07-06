{ pkgs ? import <nixpkgs> { } }: {
  ida-free = pkgs.callPackage ./ida-free { };
  libtriton = pkgs.callPackage ./triton { };
  kickoff = pkgs.callPackage ./kickoff { };
}
