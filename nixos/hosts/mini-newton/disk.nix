{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.luks.devices."luks-4e7a52b2-d4d4-4b1e-b597-75a94ecc5b94".device = "/dev/disk/by-uuid/4e7a52b2-d4d4-4b1e-b597-75a94ecc5b94";
  boot.initrd.luks.devices."luks-4e7a52b2-d4d4-4b1e-b597-75a94ecc5b94".keyFile = "/crypto_keyfile.bin";
}
