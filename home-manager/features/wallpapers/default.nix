{ lib, ... }:
{
  options.wallpaper = {
    background = lib.mkOption {
      type = lib.types.path;
      default = ./m606.jpg;
      description = "Path to the wallpaper.";
    };

    lockscreen = lib.mkOption {
      type = lib.types.path;
      default = ./stanczyk.jpg;
      description = "Path to the lockscreen.";
    };
  };
}
