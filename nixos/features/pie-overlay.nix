{ ... }:
{
  nixpkgs.overlays = [
    (
      let
        # bootstrapTools' `glibc` does not provide enough PIE linking environment.
        isGoodStdenv = stdenv: stdenv.name == "stdenv-linux";
        # Somehow ghc would'nt compile with PIE on.
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
        sphinx = super.sphinx.overridePythonAttrs (_: { doCheck = false; });
        libsecret = super.libsecret.overrideAttrs { doCheck = false; };
        zopfli = super.zopfli.overrideAttrs { doCheck = false; };
        xdg-desktop-portal = super.xdg-desktop-portal.overrideAttrs {
          mesonFlags = [ "--sysconfdir=/etc" ];
          outputs = [ "out" ];
        };
      }
    )
  ];
}
