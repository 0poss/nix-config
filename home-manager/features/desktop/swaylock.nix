{ lib, config, ... }:
{
  options = {
    swaylock = {
      enable = lib.mkEnableOption "Whether to enable swaylock";
    };
  };

  config = lib.mkIf config.swaylock.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        color = "808080";
        font-size = 24;
        indicator-idle-visible = true;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
        image = toString config.selected-lockscreen;
      };
    };
  };
}
