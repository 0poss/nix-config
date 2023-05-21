{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, fontconfig
, wayland
, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "kickoff";
  version = "v0.7.0";

  src = fetchFromGitHub {
    owner = "j0ru";
    repo = pname;
    rev = version;
    sha256 = "sha256-AolJXFolMEwoK3AtC93naphZetytzRl1yI10SP9Rnzo=";
  };

  cargoSha256 = "sha256-OEFCR/2zSVZhZqAp6n48UyIwplRXxKb9HENsVaLIKkM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fontconfig wayland libxkbcommon ];

  postFixup = let
    libPath = lib.makeLibraryPath buildInputs;
  in
    ''
    patchelf --add-rpath "${libPath}" \
             $out/bin/${pname}
    '';

  meta = with lib; {
    description = "";
    homepage = "https://github.com/j0ru/kickoff";
    license = licenses.gpl3;
    maintainers = [ maintainers.oposs ];
  };
}
