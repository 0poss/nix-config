{
  nixpkgs.overlays = [
    (
      let
        # bootstrapTools' `glibc` does not provide enough PIE linking environment.
        isGoodStdenv = stdenv: stdenv.name == "stdenv-linux";
        # These are package I didn't manage to fix.
        excluded = [ "ghc" ];
      in
      self: super: {
        stdenv = super.stdenv // super.lib.optionalAttrs (isGoodStdenv super.stdenv) {
          mkDerivation = fnOrAttrs: super.stdenv.mkDerivation (
            if builtins.isFunction fnOrAttrs then
              args: (fnOrAttrs args) // { hardeningEnable = [ "pie" ]; }
            else
              fnOrAttrs // super.lib.optionalAttrs
                (!(builtins.elem (fnOrAttrs.pname or fnOrAttrs.name) excluded))
                { hardeningEnable = [ "pie" ]; }
          );
        };

        # Fixes for broken packages built from source.
        sphinx = super.sphinx.overridePythonAttrs { doCheck = false; };
        libsecret = super.libsecret.overrideAttrs { doCheck = false; };
        zopfli = super.zopfli.overrideAttrs { doCheck = false; };
        xdg-desktop-portal = super.xdg-desktop-portal.overrideAttrs {
          mesonFlags = [ "--sysconfdir=/etc" ];
          outputs = [ "out" ];
        };
        srtp = super.srtp.overrideAttrs { doCheck = false; };
        libressl = super.libressl.overrideAttrs { doCheck = false; };
        libopus = super.libopus.overrideAttrs { doCheck = false; };
        orc = super.orc.overrideAttrs { doCheck = false; };
        sbctl = super.sbctl.overrideAttrs { doCheck = false; };
        tracker = super.tracker.overrideAttrs { doCheck = false; };
        libwacom = super.libwacom.overrideAttrs (old: {
          doCheck = false;
          buildInputs = [
            self.python3
            self.python3Packages.libevdev
            self.python3Packages.pyudev
            self.python3Packages.pytest
          ] ++ old.buildInputs;
        });
      } // (
        let
          disable-check = pkg-name:
            {
              "${pkg-name}" =
                super."${pkg-name}".overrideAttrs { doCheck = false; };
            };
        in
        disable-check "xapian" // disable-check "libuv"
      )
    )
  ];
}
