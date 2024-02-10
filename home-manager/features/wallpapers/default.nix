{ lib, ... }:
{
  options.wallpaper = {
    background = lib.mkOption {
      type = lib.types.path;
      default = ./babel.png;
      description = "Path to the wallpaper.";
    };

    lockscreen = lib.mkOption {
      type = lib.types.path;
      default = ./stanczyk.jpg;
      description = "Path to the lockscreen.";
    };
  };
}
