{
  pkgs,
  lib,
  config,
  homeConfFiles,
  inputs,
  overlays,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs homeConfFiles overlays;
    };
    users.oposs = homeConfFiles.homes.oposs;
  };

  users.users.oposs = {
    isNormalUser = true;
    description = "oposs";
    extraGroups =
      [
        "networkmanager"
        "wheel"
      ]
      ++ lib.optionals (config.virtualisation.libvirtd.enable) [ "libvirtd" ]
      ++ lib.optionals (config.programs.adb.enable) [ "adbusers" ];

    shell = pkgs.zsh;

    hashedPassword = "$6$rounds=4000000$53qnkJj1P1HQuYGO$BV812U604NaPskRAz9rnbcASym4TgaUch/oVV.tHmHf.wpCGLC4.5dcwmWIeQvvPEhwZ1tXrmaI4oQYaLC2lo0";
  };

  programs.zsh.enable = true;
}
