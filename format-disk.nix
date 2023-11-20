{ hostName, target-disk, ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = target-disk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "${hostName}-opened";
                settings.allowDiscards = true;
                extraFormatArgs = [
                  "--cipher serpent-xts-plain64"
                  "--key-size 512"
                  "--iter-time 10000"
                  #"--hash whirlpool"
                  "--label ${hostName}-crypt"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "--label ${hostName}" ];
                  subvolumes = {
                    "/fsroot" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=lzo" "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=lzo" "noatime" ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "compress=lzo" "noatime" ];
                    };
                  };
                  postCreateHook = ''
                    (
                      MNTPOINT=$(mktemp -d)
                      mount -t btrfs /dev/mapper/${hostName}-opened $MNTPOINT
                      trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
                      btrfs subvolume snapshot -r $MNTPOINT/fsroot $MNTPOINT/fsroot-blank
                    )
                  '';
                };
              };
            };
          };
        };
      };
    };
  };
}
