pkgs: {
  ida-free = pkgs.callPackage ./ida-free { };
  binary-ninja = pkgs.callPackage ./binary-ninja { };
  libtriton = pkgs.callPackage ./triton { };
  kickoff = pkgs.callPackage ./kickoff { };
}
