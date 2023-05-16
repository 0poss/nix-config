{ stdenvNoCC, lib, fetchzip }:

# Very good PR https://github.com/NixOS/nixpkgs/pull/91518/
let mkFont = args:
      let
        noUnpackFonts = lib.hasAttr "noUnpackFonts" args && args.noUnpackFonts;
        hasMultipleSources = lib.hasAttr "srcs" args;
      in
        stdenvNoCC.mkDerivation ({
          dontPatch = true;
          dontConfigure = true;
          dontBuild = true;
          doCheck = false;
          dontFixup = true;

          sourceRoot = if noUnpackFonts || hasMultipleSources then "." else null;
          unpackCmd = if noUnpackFonts then ''
    filename="$(basename "$(stripHash "$curSrc")")"
    cp $curSrc "./$filename"
  '' else null;

          /*
  installPhase = ''
    # these come up in some source trees, but are never useful to us
    find -iname __MACOSX -type d -print0 | xargs -0 rm -rf
    # find -type f,l
    for pattern in "*.ttf" "*.ttc" "*.ttf" "*.otf" "*.eot" "*.bdf" "*.otb" "*.psf"; do
      find -ipath "$pattern" | while IFS= read -r filename; do
        case "$(basename "$filename")" in
          *.ttf) fontdir=$out/share/fonts/truetype/ ;;
          *.ttc) fontdir=$out/share/fonts/truetype/ ;;
          *.ttf) fontdir=$out/share/fonts/truetype/ ;;
          *.otf) fontdir=$out/share/fonts/opentype/ ;;
          *.eot) fontdir=$out/share/fonts/eot/ ;;
          *.bdf) fontdir=$out/share/fonts/misc/ ;;
          *.otb) fontdir=$out/share/fonts/misc/ ;;
          *.psf) fontdir=$out/share/consolefonts/ ;;
          *) echo "File has invalid extension: $filename"; exit 1 ;;
        esac
        install -v -m644 --target $fontdir -D "$filename"
      done
    done
  '';
  */

          installPhase = ''
    # these come up in some source trees, but are never useful to us
    find -iname __MACOSX -type d -print0 | xargs -0 rm -rf
    find -type f,l
    find -iname '*.ttc' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/truetype/ -D
    find -iname '*.ttf' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/truetype/ -D
    find -iname '*.otf' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/opentype/ -D
    find -iname '*.bdf' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/misc/ -D
    find -iname '*.otb' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/misc/ -D
    find -iname '*.psf' -print0 | xargs -0 -r install -v -m644 --target $out/share/consolefonts/ -D
  '';
        } // args);
in
mkFont {
  pname = "intel-one-mono";
  version = "1.0.0";

  src = fetchzip {
    url = "https://github.com/intel/intel-one-mono/releases/download/V1.0.0/ttf.zip";
    sha256 = "sha256-4XE4HS25TlwXzAh41WJS3d7T2U/qO3Hm4zlvMcgEnpU=";
    stripRoot = false;
  };

  meta = with lib; {
    description = ''An expressive monospaced font family that’s built with clarity, legibility, and the needs of developers in mind.'';
    homepage = "https://github.com/intel/intel-one-mono/";
    license = licenses.ofl;
    maintainers = with maintainers; [ oposs ];
  };
}
