{ lib, ... }:
{
  console.keyMap = lib.mkDefault "fr";

  time.timeZone = lib.mkDefault "Europe/Paris";

  i18n = {
    defaultLocale = lib.mkDefault "fr_FR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = lib.mkDefault "fr_FR.UTF-8";
      LC_IDENTIFICATION = lib.mkDefault "fr_FR.UTF-8";
      LC_MEASUREMENT = lib.mkDefault "fr_FR.UTF-8";
      LC_MONETARY = lib.mkDefault "fr_FR.UTF-8";
      LC_NAME = lib.mkDefault "fr_FR.UTF-8";
      LC_NUMERIC = lib.mkDefault "fr_FR.UTF-8";
      LC_PAPER = lib.mkDefault "fr_FR.UTF-8";
      LC_TELEPHONE = lib.mkDefault "fr_FR.UTF-8";
      LC_TIME = lib.mkDefault "fr_FR.UTF-8";
    };
  };
}
