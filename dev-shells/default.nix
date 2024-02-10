{ pkgs }:
{
  clang = pkgs.callPackage ./clang.nix { };
  python = pkgs.callPackage ./python.nix { };
}
