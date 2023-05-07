{ inputs, lib, config, pkgs, ... }: {
  imports = [ ];

  nixpkgs = {
    overlays = [ ];

    config = {
      allowUnfree = false;
    };
  };

  home = {
    username = "oposs";
    homeDirectory = "/home/oposs";

    packages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      wofi
      waybar
    ];

    file = {
      ".emacs.d/init.el" = {
        source = ../emacs/init.el;
      };
    };
  };

  # home.packages = with pkgs; [ steam ];

  programs.home-manager.enable = true;
  programs.starship.enable = true;

  programs.git = {
    enable = true;
    userName = "0poss";
    userEmail = "brnnrlxndr@gmail.com";
  };

  programs.kitty = {
    enable = true;
  };

  programs.chromium = {
    enable = true;
    #package = pkgs.ungoogled-chromium;
    extensions = [
      { id = "ogfcmafjalglgifnmanfmnieipoejdcf"; } # umatrix
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
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
      terminal = "kitty";
      menu = "wofi --show run";
      startup = [ {command="emacsclient --create-frame";} ];
      input = {
        "*" = {
          xkb_layout = "fr";
        };
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
