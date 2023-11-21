{ pkgs, ... }:
{
  # Hardware support for Wayland sway
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  security.pam.services.swaylock = { };
}
