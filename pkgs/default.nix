{ pkgs }: {
  ida-free = pkgs.callPackage ./ida-free { };
  berkeley-mono = pkgs.callPackage ./berkeley-mono { };
  binary-ninja = pkgs.callPackage ./binary-ninja { };
  libtriton = pkgs.callPackage ./triton { };
  kickoff = pkgs.callPackage ./kickoff { };
}
