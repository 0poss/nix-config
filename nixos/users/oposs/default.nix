{ pkgs, ... }:
{
  users.mutableUsers = true;

  users.users.oposs = {
    isNormalUser = true;
    description = "oposs";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
}
