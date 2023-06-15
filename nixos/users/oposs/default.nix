{ pkgs, config, ... }:
{
  users.mutableUsers = true;

  users.users.oposs = {
    isNormalUser = true;
    description = "oposs";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = with pkgs; [ home-manager ];
    shell = pkgs.zsh;
  };
}
