{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence = {
    "/persist" = {
      directories = [
        "/etc/nixos"
      ];

      users.oposs = {
        directories = [
          "Documents"
          "Pictures"
          ".config"
          { directory = ".ssh"; mode = "0700"; }
        ];
      };
    };
  };
}
