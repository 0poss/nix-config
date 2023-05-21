{ pkgs }: {
  ida-free = pkgs.callPackage ./ida-free { };
  libtriton = pkgs.callPackage ./triton { };
  intel-one-mono = pkgs.callPackage ./intel-one-mono { };
  kickoff = pkgs.callPackage ./kickoff { };
}
