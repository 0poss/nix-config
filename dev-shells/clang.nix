{ pkgs, ... }:
pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
  packages = with pkgs; [
    python310
    python310Packages.ipython
    boost
    cmake
    ninja
    gef
  ];
}
