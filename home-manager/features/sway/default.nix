{ config, homeConfFiles, pkgs, lib, ... }:
let
  sway-cfg = config.wayland.windowManager.sway.config;
  colors = config.colorScheme.colors;
  inherit (builtins)
    toString;
  inherit (lib)
    listToAttrs
    nameValuePair
    range;
in
{
  imports = with homeConfFiles.features; [
    apps.chromium
    apps.i3status-rust
    apps.kickoff
    apps.kitty
    fonts
    swaylock
    wallpapers
  ];

  home.packages = with pkgs; [ grim slurp wl-clipboard ];

  wayland.windowManager.sway =
    let
      mod = sway-cfg.modifier;
      menu_prompt =
        "system: [e]xit [l]ock [r]eboot [p]oweroff [s]uspend";
      menu_mode = {
        e = "exec swaymsg exit";
        l = "exec swaylock";
        r = "exec reboot";
        p = "exec poweroff";
        s = ''exec "systemctl suspend && swaylock"'';
        Return = "mode default";
        Escape = "mode default";
        "${mod}+g" = "mode default";
      };
    in
    {
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

        startup = [{ command = "mako"; always = true; }];

        fonts = {
          names = [ config.fontProfiles.monospace.family ];
          style = "Regular";
          size = 7.5;
        };

        input = {
          "*" = {
            xkb_layout = config.home.keyboard.layout;
          };
        };

        output = {
          "*" = {
            bg = ''"'' + (toString config.wallpaper.background) + ''" fill'';
          };
        };

        floating.border = 1;

        window = {
          border = 1;
          titlebar = false;
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
            fonts = {
              names = [ config.fontProfiles.monospace.family ];
            };
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

        modes =
          let
            inherit (sway-cfg)
              left down up right;
          in
          {
            "${menu_prompt}" = menu_mode;
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

        keybindings =
          let
            mod = sway-cfg.modifier;
            inherit (sway-cfg)
              terminal menu left down up right;
          in
          let
            ws =
              if "fr" == config.home.keyboard.layout
              then {
                k1 = "ampersand";
                k2 = "eacute";
                k3 = "quotedbl";
                k4 = "apostrophe";
                k5 = "parenleft";
                k6 = "minus";
                k7 = "egrave";
                k8 = "underscore";
                k9 = "ccedilla";
                k10 = "agrave";
              }
              else
                listToAttrs
                  (map (i: nameValuePair ("k" + toString i) (toString (lib.mod i 10)))
                    (range 1 10));
          in
          {
            "${mod}+Shift+b" = "reload";

            "${mod}+Return" = "exec ${terminal}";
            "${mod}+c" = "exec chromium";
            "${mod}+e" = "exec emacs";
            "${mod}+x" = "exec ${menu}";
            "${mod}+Shift+q" = "kill";
            "${mod}+Alt+p" = ''exec grim -g "$(slurp -d)" - | wl-copy -t image/png'';

            "${mod}+o" = "split v";
            "${mod}+p" = "split h";
            "${mod}+f" = "fullscreen";
            "${mod}+Shift+space" = "floating toggle";
            "${mod}+Shift+e" = "layout toggle split";
            "${mod}+Shift+s" = "layout stacking";
            "${mod}+Shift+w" = "layout tabbed";
            "${mod}+r" = "mode resize";
            "${mod}+Shift+v" = ''mode "${menu_prompt}"'';

            "${mod}+equal" = "scratchpad show";
            "${mod}+plus" = "move scratchpad";

            "${mod}+${left}" = "focus left";
            "${mod}+${down}" = "focus down";
            "${mod}+${up}" = "focus up";
            "${mod}+${right}" = "focus right";
            "${mod}+Shift+${left}" = "move left";
            "${mod}+Shift+${down}" = "move down";
            "${mod}+Shift+${up}" = "move up";
            "${mod}+Shift+${right}" = "move right";

            "${mod}+${ws.k1}" = "workspace 1";
            "${mod}+${ws.k2}" = "workspace 2";
            "${mod}+${ws.k3}" = "workspace 3";
            "${mod}+${ws.k4}" = "workspace 4";
            "${mod}+${ws.k5}" = "workspace 5";
            "${mod}+${ws.k6}" = "workspace 6";
            "${mod}+${ws.k7}" = "workspace 7";
            "${mod}+${ws.k8}" = "workspace 8";
            "${mod}+${ws.k9}" = "workspace 9";
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
        defaultWorkspace = "workspace number 1";
      };
    };
}
