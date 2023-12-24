{
  apps = import ./apps;
  emacs = ./emacs;
  fonts = ./fonts.nix;
  shell = import ./shell;
  sway = import ./sway;
  swaylock = ./swaylock.nix;
  wallpapers = ./wallpapers;
}
