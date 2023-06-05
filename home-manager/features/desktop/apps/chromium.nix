{ pkgs, ... }:
{
  imports = [
    ../base
  ];

  programs.chromium = {
    enable = true;
    # TODO : https://discourse.nixos.org/t/home-manager-ungoogled-chromium-with-extensions/15214
    #package = pkgs.ungoogled-chromium;
    extensions = [
      # umatrix
      { id = "ogfcmafjalglgifnmanfmnieipoejdcf"; }
      # vimium
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
    ];
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
