{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
{
  hardware.enableRedistributableFirmware = true;

  boot.loader = {
    systemd-boot.enable = !config.boot.lanzaboote.enable or false;
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

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
