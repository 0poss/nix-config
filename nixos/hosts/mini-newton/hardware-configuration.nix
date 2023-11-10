{ config, pkgs, lib, ... }:
let
  inherit (config.networking) hostName;
in
{
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [ exfat ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
    "exfat"
  ];

  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [
    "kvm-intel"
    "ccm" # crypto module for networkmanager
  ];

  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."${hostName}-opened".device = "/dev/disk/by-label/${hostName}-crypt";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/NIXOS-BOOT";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
