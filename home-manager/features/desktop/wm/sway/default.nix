{ pkgs, config, lib, homeConfFiles, ... }:
let
  inherit (config.colorScheme) colors;
in
{
  imports = with homeConfFiles; [
    features.desktop.apps.chromium
    features.desktop.apps.kitty
    features.desktop.apps.i3status-rust
    features.desktop.apps.kickoff
  ];

  wayland.windowManager.sway = {
    enable = true;

    wrapperFeatures = {
      base = false;
      gtk = false;
    };

    config = {
      terminal = "kitty";
      menu = "kickoff";

      modifier = "Mod4";
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      startup = [
        { command = "mako"; always = true; }
      ];

      input = {
        "*" = {
          xkb_layout = config.home.keyboard.layout;
        };
      };

      gaps = {
        inner = 10;
      };

      colors = {
        focused = {
          background = "#${colors.base00}";
          border = "#${colors.base01}";
          text = "#${colors.base05}";
          indicator = "#${colors.base09}";
          childBorder = "#${colors.base0C}";
        };
      };

      bars = [
        {
          statusCommand =
            "i3status-rs ~/.config/i3status-rust/config-default.toml";
          position = "bottom";
          colors = {
            background = "#${colors.base00}";
            statusline = "#${colors.base00}";
            separator = "#${colors.base05}";
            focusedWorkspace = {
              background = "#${colors.base00}";
              border = "#${colors.base02}";
              text = "#${colors.base05}";
            };
          };
        }
      ];

      modes = with lib;
        let mod = config.wayland.windowManager.sway.config.modifier;
            inherit (config.wayland.windowManager.sway.config)
              terminal menu left down up right;
        in
          {
            "system: [e]xit [r]eboot [p]oweroff [h]ibernate" = {
              e = "exec swaymsg exit";
              r = "exec reboot";
              p = "exec poweroff";
              h = "systemctl hibernate";
              Return = "mode default";
              Escape = "mode default";
              "${mod}+g" = "mode default";
            };
            resize = {
              "${mod}+${left}" = "resize shrink width 10 px";
              "${mod}+${down}" = "resize grow height 10 px";
              "${mod}+${up}" = "resize shrink height 10 px";
              "${mod}+${right}" = "resize grow width 10 px";
              Return = "mode default";
              Escape = "mode default";
              "${mod}+g" = "mode default";
            };
          };
      
      keybindings = with lib;
        let mod = config.wayland.windowManager.sway.config.modifier;
            inherit (config.wayland.windowManager.sway.config)
              terminal menu left down up right;
        in
          let ws = if "fr" == config.home.keyboard.layout
                   then { k1 = "ampersand";
                          k2 = "eacute";
                          k3 = "quotedbl";
                          k4 = "apostrophe";
                          k5 = "parenleft";
                          k6 = "egrave";
                          k7 = "minus";
                          k8 = "underscore";
                          k9 = "ccedilla";
                          k10 = "agrave"; }
                   else listToAttrs
                     (map (k: nameValuePair (toString k) (toString (trivial.modulo k 10)))
                       (range 1 10));
          in
            {
              "${mod}+Shift+b" = "reload";

              "${mod}+Return" = "exec ${terminal}";
              "${mod}+e" = "exec emacsclient --create-frame";
              "${mod}+d" = "exec ${menu}";
              "${mod}+Shift+q" = "kill";

              "${mod}+o" = "split v";
              "${mod}+p" = "split h";
              "${mod}+f" = "fullscreen";
              "${mod}+Shift+space" = "floating toggle";
              "${mod}+Shift+e" = "layout toggle split";
              "${mod}+Shift+s" = "layout stacking";
              "${mod}+Shift+w" = "layout tabbed";
              "${mod}+r" = "mode resize";
              "${mod}+Shift+v" = ''mode "system: [e]xit [r]eboot [p]oweroff [h]ibernate"'';

              "${mod}+${left}" = "focus left";
              "${mod}+${down}" = "focus down";
              "${mod}+${up}" = "focus up";
              "${mod}+${right}" = "focus right";
              "${mod}+Shift+${left}" = "move left";
              "${mod}+Shift+${down}" = "move down";
              "${mod}+Shift+${up}" = "move up";
              "${mod}+Shift+${right}" = "move right";

              "${mod}+${ws.k1}" =  "workspace 1";
              "${mod}+${ws.k2}" =  "workspace 2";
              "${mod}+${ws.k3}" =  "workspace 3";
              "${mod}+${ws.k4}" =  "workspace 4";
              "${mod}+${ws.k5}" =  "workspace 5";
              "${mod}+${ws.k6}" =  "workspace 6";
              "${mod}+${ws.k7}" =  "workspace 7";
              "${mod}+${ws.k8}" =  "workspace 8";
              "${mod}+${ws.k9}" =  "workspace 9";
              "${mod}+${ws.k10}" = "workspace 10";

              "${mod}+Shift+${ws.k1}" = "move container to workspace number 1";
              "${mod}+Shift+${ws.k2}" = "move container to workspace number 2";
              "${mod}+Shift+${ws.k3}" = "move container to workspace number 3";
              "${mod}+Shift+${ws.k4}" = "move container to workspace number 4";
              "${mod}+Shift+${ws.k5}" = "move container to workspace number 5";
              "${mod}+Shift+${ws.k6}" = "move container to workspace number 6";
              "${mod}+Shift+${ws.k7}" = "move container to workspace number 7";
              "${mod}+Shift+${ws.k8}" = "move container to workspace number 8";
              "${mod}+Shift+${ws.k9}" = "move container to workspace number 9";
              "${mod}+Shift+${ws.k10}" = "move container to workspace number 10";
            };
    };
  };
}
