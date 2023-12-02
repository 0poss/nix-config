{ config, pkgs, ... }:
{
  hardware.enableRedistributableFirmware = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [
    "kvm-intel"
    "ccm"
  ];

  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
