{ lib
, stdenv
, fetchurl
, fetchzip
, hashes ? (builtins.fromJSON (fetchurl "https://binary.ninja/js/hashes.js"))
, pname ? "BinaryNinja-personal"
, src ? fetchzip {
    url = pname + ".zip";
    sha256 = hashes.hashes."${pname}.zip";
  }
, version ? hashes.version
}:
stdenv.mkDerivation {
  inherit src version pname;

  meta = with lib; {
    description = "Interactive decompiler, disassembler, debugger, and binary analysis platform built by reverse engineers, for reverse engineers.";
    homepage = "https://binary.ninja/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86-64-linux" ];
  };
}
