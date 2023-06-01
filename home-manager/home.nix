{ pkgs, config, lib, nix-colors, overlays, ... }: {
  imports = [ nix-colors.homeManagerModules.default ];

  nixpkgs = {
    overlays = lib.attrValues overlays;

    config = {
      allowUnfree = false;
    };
  };

  colorScheme = nix-colors.colorSchemes.bright;
  fonts.fontconfig.enable = true;

  home = {
    username = "oposs";
    homeDirectory = "/home/oposs";

    keyboard.layout = "fr";

    packages = with pkgs; [
      clang
      clang-tools
      cmake
      gnumake
      python3
      python3Packages.ipython

      (nerdfonts.override { fonts = [ "Terminus" "Iosevka" ]; })

      bat
      swaylock
      swayidle
      libnotify
      wl-clipboard
      kickoff
      grim
      slurp
      pfetch

      (ida-free.overrideAttrs (oldAttrs: { meta.licence = null; }))
      hugo
      go
      nodejs
    ];
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "0poss";
    userEmail = "brnnrlxndr@gmail.com";
  };

  services.mako = {
    enable = true;
  };

  #
  # Configure kitty
  #
  programs.kitty = {
    enable = true;
    font = {
      name = "TerminessTTF Nerd Font";
      size = 12;
    };
    settings = with config.colorScheme; {
      cursor_shape = "beam";
      scrollback_lines = 4000;
      scrollback_pager_history_size = 2048;
      window_padding_width = 5;
      foreground = "#${colors.base05}";
      background = "#${colors.base00}";
      selection_background = "#${colors.base05}";
      selection_foreground = "#${colors.base00}";
      url_color = "#${colors.base04}";
      cursor = "#${colors.base05}";
      active_border_color = "#${colors.base03}";
      inactive_border_color = "#${colors.base01}";
      active_tab_background = "#${colors.base00}";
      active_tab_foreground = "#${colors.base05}";
      inactive_tab_background = "#${colors.base01}";
      inactive_tab_foreground = "#${colors.base04}";
      tab_bar_background = "#${colors.base01}";
      color0 = "#${colors.base00}";
      color1 = "#${colors.base08}";
      color2 = "#${colors.base0B}";
      color3 = "#${colors.base0A}";
      color4 = "#${colors.base0D}";
      color5 = "#${colors.base0E}";
      color6 = "#${colors.base0C}";
      color7 = "#${colors.base05}";
      color8 = "#${colors.base03}";
      color9 = "#${colors.base08}";
      color10 = "#${colors.base0B}";
      color11 = "#${colors.base0A}";
      color12 = "#${colors.base0D}";
      color13 = "#${colors.base0E}";
      color14 = "#${colors.base0C}";
      color15 = "#${colors.base07}";
      color16 = "#${colors.base09}";
      color17 = "#${colors.base0F}";
      color18 = "#${colors.base01}";
      color19 = "#${colors.base02}";
      color20 = "#${colors.base04}";
      color21 = "#${colors.base06}";
    };
  };

  programs.chromium = {
    enable = true;
    #package = pkgs.ungoogled-chromium;
    extensions = [
      { id = "ogfcmafjalglgifnmanfmnieipoejdcf"; } # umatrix
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
    commandLineArgs = [
      "--js-flags=--jitless"
      "--js-flags=--noexpose_wasm"
      "--disable-3d-apis"
    ];
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "javascript.options.baselinejit" = false;
      "javascript.options.wasm" = false;
      "webgl.disabled" = true; # Set to true by default
    };
  };

  #
  # Sway configuration
  #
  home.file."Pictures/Wallpapers/".source = ../wallpapers;
  wayland.windowManager.sway = {
    enable = true;

    wrapperFeatures = {
      base = false;
      gtk = false;
    };

    config = {
      modifier = "Mod4";
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      terminal = "kitty";
      menu = "kickoff";

      startup = [
        { command = "mako"; always = true; }
      ];

      input = {
        "*" = {
          xkb_layout = config.home.keyboard.layout;
        };
      };

      output = {
        "*" = {
          bg = ''"'' + (builtins.toString ../wallpapers/m606.jpg) + ''" fill'';
        };
      };

      gaps = {
        inner = 10;
      };

      colors = with config.colorScheme; {
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
          statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
          position = "bottom";
          colors = with config.colorScheme; {
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

  #
  # Configure i3status-rust
  #
  programs.i3status-rust = {
    enable = true;
    package = pkgs.unstable.i3status-rust;
    bars = {
      default = {
        settings.theme = with config.colorScheme; {
          theme = "slick";
          overrides = {
            idle_bg = "#${colors.base00}";
            idle_fg = "#${colors.base05}";
          };
        };
        blocks = let
          notify = "notify-send -t 7500";
        in
          [
            { block = "menu";
              text = " Nix ";
              items = [
                { display = " Collect garbage ";
                  cmd = ''${notify} "$(nix-collect-garbage -d 2>&1 | tail -n 2)"''; }
                { display = " Optimize store ";
                  cmd = ''${notify} "$(nix-store --optimise 2>&1 | tail -n 2)"''; }
              ];
            }
            { block = "external_ip";
              format = " $ip $country_code "; }
            { block = "cpu"; }
            { block = "memory";
              format = " $icon $mem_used_percents.eng(w:2) ";
              format_alt = " $icon_swap $swap_used_percents.eng(w:2) "; }
            { block = "disk_space";
              path = "/";
              info_type = "available";
              alert_unit = "GB";
              interval = 20;
              warning = 100;
              alert = 40;
              format = " $icon $path: $available/$total ";
              click = [
                { button = "right"; update = true; }
                { button = "left"; update = true; }
              ];
            }
          ];
      };
    };
  };

  #
  # Configure kickoff
  #
  home.file.".config/kickoff/config.toml".text = with config.colorScheme; ''
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

  #
  # Emacs configuration
  #
  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.emacs = {
    enable = true;
  };

  # Import my config
  home.file.".emacs.d/init.el".source = ../emacs/init.el;
  home.file.".emacs.d/config.org".source = ../emacs/config.org;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
