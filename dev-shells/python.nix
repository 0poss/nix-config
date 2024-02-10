{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    python310
    python310Packages.ipython
  ];
}
