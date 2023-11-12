{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, fontconfig
, wayland
, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "kickoff";
  version = "v0.7.1";

  src = fetchFromGitHub {
    owner = "j0ru";
    repo = pname;
    rev = version;
    sha256 = "sha256-9QupKpB3T/6gdGSeLjRknjPdgOzbfzEeJreIamWwpSw=";
  };

  cargoSha256 = "sha256-PEOvz3m8/9gsWfczfNYMqXU5+Ga3ylE036vUheY2LB0=";

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
