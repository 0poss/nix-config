{ lib, config, ... }:
let
  hostName = config.networking.hostName;
  wipeScript = ''
    mkdir -vp /tmp
    MNTPOINT=$(mktemp -d)
    (
      mount -t btrfs -o subvol=/ /dev/disk/by-label/${hostName} "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      echo "Creating needed directories"
      mkdir -vp "$MNTPOINT"/persist/etc/nixos

      echo "Cleaning root subvolume"
      btrfs subvolume list -o "$MNTPOINT/fsroot" | cut -f9 -d ' ' |
      while read -r subvolume; do
        btrfs subvolume delete "$MNTPOINT/$subvolume"
      done && btrfs subvolume delete "$MNTPOINT/fsroot"

      echo "Restoring blank subvolume"
      btrfs subvolume snapshot "$MNTPOINT/fsroot-blank" "$MNTPOINT/fsroot"
    )
  '';
in
{
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postDeviceCommands = lib.mkBefore wipeScript;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=fsroot" "compress=lzo" "noatime" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=lzo" "noatime" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=lzo" "noatime" ];
      neededForBoot = true;
    };
  };
}
