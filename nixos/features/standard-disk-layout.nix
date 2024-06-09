{ lib, config, ... }:
let
  inherit (config.networking) hostName;
  cfg = config.features.standard-disk-layout;
in
{
  options.features.standard-disk-layout = {
    ephemeral-btrfs.enable = lib.mkEnableOption "Whether to enable ephemeral btrfs";
    encryption.enable = lib.mkEnableOption "Whether the root partition is encrypted";
  };

  config = {
    fileSystems =
      {
        "/" = {
          device = "/dev/mapper/${hostName}-opened";

          fsType = if cfg.ephemeral-btrfs.enable then "btrfs" else "auto";
          options =
            if cfg.ephemeral-btrfs.enable then
              [
                "subvol=fsroot"
                "compress=lzo"
                "noatime"
              ]
            else
              [ "defaults" ];

          encrypted = lib.mkIf cfg.encryption.enable {
            enable = true;
            label = "${hostName}-opened";
            blkDev = "/dev/disk/by-label/${hostName}-crypt";
          };
        };

        "/boot" = {
          device = "/dev/disk/by-label/NIXOS-BOOT";
          fsType = "vfat";
        };
      }
      // lib.optionalAttrs cfg.ephemeral-btrfs.enable {
        "/nix" = {
          device = "/dev/disk/by-label/${hostName}";
          fsType = "btrfs";
          options = [
            "subvol=nix"
            "compress=lzo"
            "noatime"
          ];
        };

        "/persist" = {
          device = "/dev/disk/by-label/${hostName}";
          fsType = "btrfs";
          options = [
            "subvol=persist"
            "compress=lzo"
            "noatime"
          ];
          neededForBoot = true;
        };
      };

    boot.initrd = lib.mkIf cfg.ephemeral-btrfs.enable {
      supportedFilesystems = [ "btrfs" ];
      postDeviceCommands = lib.mkBefore ''
            mkdir -vp /tmp
            MNTPOINT=$(mktemp -d)
            (
              mount -t btrfs -o subvol=/ /dev/disk/by-label/${hostName} "$MNTPOINT"
              trap 'umount "$MNTPOINT"; rm -rf $MNTPOINT' EXIT

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
    };
  };
}
