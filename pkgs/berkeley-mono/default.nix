{ lib
, stdenvNoCC
, requireFile
, unzip }:

stdenvNoCC.mkDerivation {
  name = "berkeley-mono";

  src = requireFile rec {
    name = "berkeley-mono-typeface.zip";
    url = "https://berkeleygraphics.com/typefaces/berkeley-mono/";
    sha256 = "1m2wfr4vfl889g1y0ww76sj050jl0sb8wbv4yycxy0pkw9591jb8";
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