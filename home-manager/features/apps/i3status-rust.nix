{ pkgs, lib, config, ... }:
let
  colors = config.colorScheme.colors;
in
{
  options = {
    i3status-rust = {
      has-backlight = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable backlight block in the default bar";
      };
    };
  };

  config = {
    programs.i3status-rust = {
      enable = true;
      package = pkgs.i3status-rust;
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

            lib.optionals config.i3status-rust.has-backlight [
              {
                block = "backlight";
                device = "intel_backlight";
              }

              {
                block = "battery";
                format = " $icon $percentage ";
                full_threshold = 80;
                good = 80;
                warning = 20;
                critical = 10;
                empty_threshold = 5;
              }
            ]

            ++ [

              {
                block = "sound";
              }

              {
                block = "memory";
                format = " $icon $mem_total_used/$mem_total $mem_used_percents.eng(w:2) ";
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
                format = " $icon $path: $used/$total ";
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
  };
}
