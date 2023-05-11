{ pkgs, config, lib, nix-colors, ... }: {
  imports = [ nix-colors.homeManagerModules.default ];

  nixpkgs = {
    overlays = [ ];

    config = {
      allowUnfree = false;
    };
  };

  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
  fonts.fontconfig.enable = true;

  home = {
    username = "oposs";
    homeDirectory = "/home/oposs";

    keyboard.layout = "fr";

    packages = with pkgs; [
      python3
      python3Packages.ipython

      swaylock
      swayidle
      wl-clipboard
      mako
      wofi
      waybar
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];

    file = {
      ".emacs.d/init.el" = {
        source = ../emacs/init.el;
      };
    };
  };

  #home.packages = with pkgs; [ steam ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "0poss";
    userEmail = "brnnrlxndr@gmail.com";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka";
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

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.emacs = {
    enable = true;
  };

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
      menu = "wofi --show run";

      startup = [ ];

      input = {
        "*" = {
          xkb_layout = config.home.keyboard.layout;
        };
      };

      gaps = {
        inner = 10;
      };

      keybindings = with lib;
        let mod = config.wayland.windowManager.sway.config.modifier;
            inherit (config.wayland.windowManager.sway.config)
              terminal menu left down up right;
        in
          let ws = if "fr" == config.home.keyboard.layout
                   then { "1" = "ampersand";
                          "2" = "eacute";
                          "3" = "quotedbl";
                          "4" = "apostrophe";
                          "5" = "parenleft";
                          "6" = "egrave";
                          "7" = "minus";
                          "8" = "underscore";
                          "9" = "ccedilla";
                          "10" = "agrave"; }
                   else listToAttrs
                     (map (k: nameValuePair (toString k) (toString (trivial.modulo k 10)))
                       (range 1 10));
          in
            {
              "${mod}+Shift+b" = "reload";
              "${mod}+Shift+o" = "exec swaymsg exit";

              "${mod}+Return" = "exec ${terminal}";
              "${mod}+e" = "exec emacsclient --create-frame";
              "${mod}+d" = "exec ${menu}";
              "${mod}+Shift+q" = "kill";

              "${mod}+f" = "fullscreen";
              "${mod}+space" = "floating toggle";
              "${mod}+Shift+e" = "layout split";
              "${mod}+Shift+s" = "layout stacking";
              "${mod}+Shift+w" = "layout tabbed";

              "${mod}+${left}" = "focus left";
              "${mod}+${down}" = "focus down";
              "${mod}+${up}" = "focus up";
              "${mod}+${right}" = "focus right";
              "${mod}+Shift+${left}" = "move left";
              "${mod}+Shift+${down}" = "move down";
              "${mod}+Shift+${up}" = "move up";
              "${mod}+Shift+${right}" = "move right";

              "${mod}+${ws."1"}" =  "workspace 1";
              "${mod}+${ws."2"}" =  "workspace 2";
              "${mod}+${ws."3"}" =  "workspace 3";
              "${mod}+${ws."4"}" =  "workspace 4";
              "${mod}+${ws."5"}" =  "workspace 5";
              "${mod}+${ws."6"}" =  "workspace 6";
              "${mod}+${ws."7"}" =  "workspace 7";
              "${mod}+${ws."8"}" =  "workspace 8";
              "${mod}+${ws."9"}" =  "workspace 9";
              "${mod}+${ws."10"}" = "workspace 10";

              "${mod}+Shift+${ws."1"}" = "move container to workspace number 1";
              "${mod}+Shift+${ws."2"}" = "move container to workspace number 2";
              "${mod}+Shift+${ws."3"}" = "move container to workspace number 3";
              "${mod}+Shift+${ws."4"}" = "move container to workspace number 4";
              "${mod}+Shift+${ws."5"}" = "move container to workspace number 5";
              "${mod}+Shift+${ws."6"}" = "move container to workspace number 6";
              "${mod}+Shift+${ws."7"}" = "move container to workspace number 7";
              "${mod}+Shift+${ws."8"}" = "move container to workspace number 8";
              "${mod}+Shift+${ws."9"}" = "move container to workspace number 9";
              "${mod}+Shift+${ws."10"}" = "move container to workspace number 10";
            };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
