{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence = {
    "/persist" = {
      directories = [
        "/etc/nixos"
        "/var/log"
      ];

      users.oposs = {
        directories = [
          "Documents"
          "Pictures"
          ".config"
	  ".emacs.d"
          { directory = ".ssh"; mode = "0700"; }
          { directory = ".gnupg"; mode = "0700"; }
        ];
      };
    };
  };
}
