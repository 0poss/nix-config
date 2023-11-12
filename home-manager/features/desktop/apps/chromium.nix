{ pkgs, ... }:
{
  imports = [ ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      # Disable JIT.
      "--js-flags=--jitless"
      # Disable wasm.
      "--js-flags=--noexpose_wasm"
      # Disable WebGL.
      "--disable-3d-apis"
    ];
  };
}
