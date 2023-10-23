{ pkgs, lib, config, ... }:
let
  inherit (config.colorscheme) colors;
  has-backlight = config.programs.i3status-rust.backlight;
in
{
  imports = [ ];

  options.programs.i3status-rust.backlight = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable backlight block in the default bar.";
    example = "true";
  };

  config.programs.i3status-rust = {
    enable = true;
    package = pkgs.unstable.i3status-rust;
    bars = {
      default = {
        settings.theme = {
          theme = "slick";
          overrides = {
            idle_bg = "#${colors.base00}";
            idle_fg = "#${colors.base05}";
          };
        };
        blocks =
          let
            notify = "notify-send -t 7500";
          in
          [
            {
              block = "menu";
              text = " Nix ";
              items = [
                {
                  display = " Collect garbage ";
                  cmd = ''${notify} "$(nix-collect-garbage -d 2>&1 | tail -n 2)"'';
                }
                {
                  display = " Optimize store ";
                  cmd = ''${notify} "$(nix-store --optimise 2>&1 | tail -n 2)"'';
                }
              ];
            }

            {
              block = "net";
              format = " $icon {$signal_strength $ssid $frequency|Wired connection} via $device ";
            }

            { block = "cpu"; }

          ] ++

          lib.optionals has-backlight [
            {
              block = "backlight";
              device = "intel_backlight";
            }
          ]

          ++ [

            {
              block = "memory";
              format = " $icon $mem_used_percents.eng(w:2) ";
              format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
            }

            {
              block = "disk_space";
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

            {
              block = "time";
              interval = 5;
              format = {
                full = " $timestamp.datetime(f:'%a %Y-%m-%d %R %Z', l:en_US) ";
                short = " $timestamp.datetime(f:%R) ";
              };
            }
          ];
      };
    };
  };
}
