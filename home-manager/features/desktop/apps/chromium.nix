{ lib, pkgs, config, ... }:
{
  options = {
    chromium = {
      enable = lib.mkEnableOption "Whether to enable chromium";
      enable-hardening = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''Whether to "harden" the chromium'';
      };
    };
  };

  config = lib.mkIf config.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = lib.mkIf config.chromium.enable-hardening [
        "--disable-top-sites"
        "--disable-webgl"
        "--remove-cross-origin-referrers"
        "--js-flags=--noexpose_wasm"
        "--js-flags=--jitless"
      ];
    };
  };
}
