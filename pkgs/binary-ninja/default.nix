{ lib
, stdenv
, autoPatchelfHook
, copyDesktopItems
, dbus
, fontconfig
, freetype
, libGL
, libxkbcommon
, makeDesktopItem
, requireFile
, unzip
, wayland-scanner
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  name = "binary-ninja";

  src = requireFile rec {
    name = "BinaryNinja-personal.zip";
    url = "https://binary.ninja/recover/";
    sha256 = "0391hfyq80k5jrxj6nkfgijxq5f9wkycpqr60dw86flv2rcpj7n2";
    message = ''
      Stable download URLs for Binary Ninja are not available.
      Please visit ${url} and find the download link for ${name},
      then add it to the Nix store with this command:

        nix-prefetch-url --name ${name} --type sha256 <URL>
    '';
  };

  installPhase = ''
    mkdir -p $out/share/${name}
    cp -r * $out/share/${name}
  '';

  buildInputs = [
    dbus # libdbus-1.so.3
    fontconfig.lib # libfontconfig.so.1
    freetype # libfreetype.so.6
    libGL # libGL.so.1
    libxkbcommon # libxkbcommon.so.0
    stdenv.cc.cc.lib # libstdc++.so.6
    wayland-scanner.out # libwayland-client.so.0 libwayland-egl.so.1
    xorg.xcbutilimage # libxcb-image.so.0
    xorg.xcbutilkeysyms # libxcb-keysyms.so.1
    xorg.xcbutilrenderutil # libxcb-keysyms.so.1
    xorg.xcbutilwm # libxcb-icccm.so.4
    zlib # libz.so.1
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    unzip
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libQt6Qml.so.6"
    "libQt6PrintSupport.so.6"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "binary-ninja";
      desktopName = "Binary Ninja";
      icon = "binary-ninja";
      exec = "binaryninja";
    })
  ];

  meta = with lib; {
    description = "Interactive decompiler, disassembler, debugger, and binary analysis platform built by reverse engineers, for reverse engineers.";
    homepage = "https://binary.ninja/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    #license = licenses.unfree;
    #platforms = [ "x86_64-linux" ];
  };
}
