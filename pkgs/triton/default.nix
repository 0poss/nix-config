{ stdenv
, fetchFromGitHub
, z3
, llvm
, python3
, boost
, capstone
, cmake }:

stdenv.mkDerivation {
  pname = "libtriton";
  version = "dev-v1.0";

  src = fetchFromGitHub {
    owner = "JonathanSalwan";
    repo = "Triton";
    rev = "6932ad228b093929c9794ed53d3966e49fd23596";
    sha256 = "sha256-lbohwYhgyK9N6WcBQUdzjaPVmx6/Pse2Ac9Jcpk+8wI=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ python3 boost capstone z3 llvm ];

  cmakeFlags = [
    "-DLLVM_INTERFACE=ON"
  ];
}
