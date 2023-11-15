{ pkgs, ... }:
{
  imports = [ ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--disable-top-sites"
      "--disable-webgl"
      "--remove-cross-origin-referrers"
      "--js-flags=--noexpose_wasm"
      "--js-flags=--jitless"
    ];
  };
}
