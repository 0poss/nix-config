{
  lib,
  stdenvNoCC,
  requireFile,
  unzip,
  sha256 ? "17cqpql8zvakczvjhbzp6mgxvr137av2nik53p0ylk6gwjlqklv1",
}:
stdenvNoCC.mkDerivation {
  name = "berkeley-mono";

  src = requireFile rec {
    name = "berkeley-mono-typeface.zip";
    url = "https://berkeleygraphics.com/typefaces/berkeley-mono/";
    inherit sha256;
    message = ''
      Stable download URLs for Berkeley Mono Typeface are not available.
      Please visit ${url} and find the download link for ${name},
      then add it to the Nix store with this command:

        nix-prefetch-url --name ${name} --type sha256 <URL>
    '';
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    ls -lAh *
    mkdir -vp $out/share/fonts/{,truetype}

    mv -v berkeley-mono/OTF $out/share/fonts/opentype
    mv -v berkeley-mono{,variable}/TTF/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A love letter to the golden era of computing.";
    homepage = "https://berkeleygraphics.com/typefaces/berkeley-mono/";
    #license = licenses.unfree;
    platforms = platforms.all;
  };
}
