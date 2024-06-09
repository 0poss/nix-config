{ lib, ... }:
let
  inherit (builtins) elem listToAttrs;
  inherit (lib) optionals;

  pie-exclusion-list = [ "ghc" ];

  # TODO: why did I do this ? I can just use `pkgs.overrideAttrs (old: ...)'.
  append-pie-flag =
    attr:
    if elem (attr.pname or attr.name) pie-exclusion-list then
      attr
    else
      let
        old-flags = attr.hardeningEnable or [ ];
        addend = optionals (!(elem "pie" old-flags)) [ "pie" ];
        new-flags = old-flags ++ addend;
      in
      attr // { hardeningEnable = new-flags; };

  pie-mkDerivation =
    super-mkDerivation: fnOrAttrs:
    if builtins.isFunction fnOrAttrs then
      super-mkDerivation (args: append-pie-flag (fnOrAttrs args))
    else
      super-mkDerivation (append-pie-flag fnOrAttrs);

  disable-check-ctor = pkgs: pkg-name: {
    name = pkg-name;
    value = pkgs."${pkg-name}".overrideAttrs { doCheck = false; };
  };

  disable-checks-for = [
    # Timeouts due to CPU-intensive build processes.
    # Disabling checks for those packages is a solution.
    # Another is to build the package using `nix build' and then
    #   re-issuing a `nixos-rebuild'.
    # Some packages here
    "gitMinimal"
    "libopus"
    "dconf"
    "orc"
    "dbus-python"
    "tracker"
    "openexr"
    "python311Packages.hypothesis"

    # Broken tests.
    # These are not test failures but misconfigured configurqtions that result
    #   in the tests not running at all. in the tests not running at all.
    "sbctl"

    # Tests that don't work but idc
    "libpulseaudio"
  ];

  pie-overlay =
    final: prev:
    {
      stdenv = prev.stdenv // {
        mkDerivation = pie-mkDerivation prev.stdenv.mkDerivation;
      };
      libwacom = prev.libwacom.overrideAttrs (old: {
        doCheck = false;
        buildInputs = [
          final.python3
          final.python3Packages.libevdev
          final.python3Packages.pyudev
          final.python3Packages.pytest
        ] ++ old.buildInputs;
      });
    }
    // listToAttrs (map (disable-check-ctor prev) disable-checks-for);
in
{
  nixpkgs.overlays = [ pie-overlay ];
}
