{ lib, ... }:
{
  options.selected-wallpaper = lib.mkOption {
    type = lib.types.path;
    default = ./ohms.png;
    description = "Path to the wallpaper.";
  };

  options.selected-lockscreen = lib.mkOption {
    type = lib.types.path;
    default = ./stanczyk.jpg;
    description = "Path to the lockscreen.";
  };
}
