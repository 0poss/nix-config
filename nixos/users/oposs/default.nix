{ pkgs, nixosConfFiles, ... }:
{
  imports = with nixosConfFiles; [
    users.base
  ];

  users.users.oposs = {
    isNormalUser = true;
    description = "oposs";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = with pkgs; [ home-manager git ];
    shell = pkgs.zsh;

    hashedPassword = "$6$rounds=4000000$53qnkJj1P1HQuYGO$BV812U604NaPskRAz9rnbcASym4TgaUch/oVV.tHmHf.wpCGLC4.5dcwmWIeQvvPEhwZ1tXrmaI4oQYaLC2lo0";
  };
}
