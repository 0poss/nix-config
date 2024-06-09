{
  inputs,
  homeConfFiles,
  overlays,
  pkgs,
  nixosConfFiles,
  ...
}:
{
  imports = with nixosConfFiles; [
    inputs.home-manager.nixosModules.home-manager
    features.wayland
    features.nixpkgs
    features.locale
    features.pie-overlay
  ];

  services.logrotate.checkConfig = false;

  users.users.root.hashedPassword = "$6$rounds=50000000$cvIEZAR5IvtCciec$s2or9o8yAwnPO2gJmTE78Av3NJJRYXSsfBi1Rnf0IzU/0NsYENzDhBvszqWs2wZeEZ2qENawAMbjbbXVxvdwJ.";

  programs.sway.enable = true;

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 8;
      #https://discourse.nixos.org/t/problem-with-sway-in-nixos-rebuild-build-vm-how-to-configure-vm/20263/2
      qemu.options = [
        "-vga none"
        "-device virtio-vga-gl"
        "-display gtk,gl=on"
      ];
    };
  };

  nix.settings.substituters = [ ];
  system.stateVersion = "23.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  home-manager = {
    extraSpecialArgs = {
      inherit inputs homeConfFiles overlays;
    };
    users.oposs = homeConfFiles.homes.oposs;
  };

  users.mutableUsers = false;
  users.users.oposs = {
    isNormalUser = true;
    description = "oposs";
    extraGroups = [ "wheel" ];

    packages = with pkgs; [
      git
      #binary-ninja
    ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$3ikX9sUneJBNeiJG5jdst1$2AAzLD2pkDVORF61mua5GtezE8du.07jaPCkvz0ytK8";
  };
  programs.zsh.enable = true;

  networking.hostName = "puffy";
}
