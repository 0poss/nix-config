{ pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/hardened.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_1_hardened;

  systemd.coredump.enable = false;
}
