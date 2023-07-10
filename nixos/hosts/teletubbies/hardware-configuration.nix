{ config, lib, modulesPath, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "ccm"
  ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."${hostName}-opened".device = "/dev/disk/by-label/${hostName}-crypt";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/NIXOS-BOOT";
      fsType = "vfat";
    };

  swapDevices = [
    { device = "/dev/disk/by-partuuid/9760dc3d-5f76-1646-bb18-351bd1f1c780";
      randomEncryption = {
        cipher = "serpent-xts-plain64";
        enable = true;
      };
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
