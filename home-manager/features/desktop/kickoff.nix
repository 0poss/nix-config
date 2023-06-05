{ pkgs, config, ... }:
let
  inherit (config.colorscheme) colors;
in
{
  home.file.".config/kickoff/config.toml".text = ''
  prompt = ">  "
  padding = 500
  font_size = 32.0
  fonts = [ "TerminessTTF Nerd Font" ]

  [colors]
  background = "#${colors.base00}aa"
  prompt = "#${colors.base0C}ff"
  text = "#${colors.base05}ff"
  text_query = "#${colors.base06}ff"
  text_selected = "#${colors.base0E}ff"

  [keybindings]
  # A list of available keys can be found here: https://docs.rs/crate/x11-keysymdef/0.2.0/source/src/keysym.json
  paste = ["ctrl+v"]
  execute = ["KP_Enter", "Return"]
  delete = ["KP_Delete", "Delete", "BackSpace"]
  delete_word = ["ctrl+KP_Delete", "ctrl+Delete", "ctrl+BackSpace"]
  complete = ["Tab"]
  nav_up = ["Up", "ctrl+p"]
  nav_down = ["Down", "ctrl+n"]
  exit = ["Escape"]
  '';
}
