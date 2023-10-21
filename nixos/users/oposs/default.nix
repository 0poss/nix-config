{ pkgs, lib, config, nixosConfFiles, homeConfFiles, inputs, overlays, ... }:
{
  imports = with nixosConfFiles; [
    inputs.home-manager.nixosModules.home-manager
    users.base
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs homeConfFiles overlays; };
    users.oposs = homeConfFiles.homes.oposs;
  };

  users.users.oposs = {
    isNormalUser = true;
    description = "oposs";
    extraGroups = [
      "networkmanager"
      "wheel"
    ] ++ lib.optionals (config.virtualisation.libvirtd.enable) [ "libvirtd" ];

    packages = with pkgs; [ home-manager git ];
    shell = pkgs.zsh;

    hashedPassword = "$6$rounds=4000000$53qnkJj1P1HQuYGO$BV812U604NaPskRAz9rnbcASym4TgaUch/oVV.tHmHf.wpCGLC4.5dcwmWIeQvvPEhwZ1tXrmaI4oQYaLC2lo0";
  };
}
