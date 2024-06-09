{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  programs.fuse.userAllowOther = true;

  environment.persistence = {
    "/persist" = {
      directories = [
        "/etc/nixos"
        "/etc/secureboot"
        "/var/log"
      ];

      users.oposs = {
        directories = [
          #"Documents"
          #"Pictures"
          ".config"
          #".emacs.d"
          #{ directory = ".ssh"; mode = "0700"; }
          #{ directory = ".gnupg"; mode = "0700"; }
        ];
      };
    };
  };
}
