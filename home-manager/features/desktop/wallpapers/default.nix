{ lib, ... }:
{
  options.selectedWallpaper = lib.mkOption {
    type = lib.types.path;
    default = ./m606.jpg;
    description = "Path to the wallpaper";
  };
}
