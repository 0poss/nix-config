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
, makeWrapper
, requireFile
, unzip
, wayland-scanner
, python310
, xorg
, zlib
}:

stdenv.mkDerivation {
  name = "binary-ninja";

  src = requireFile rec {
    name = "BinaryNinja-personal.zip";
    url = "https://binary.ninja/recover/";
    sha256 = "1hq8w2l0jrvll9gynzzhyzs8vkrsj31gbvp4v13hqr857rkf2j6w";
    message = ''
      Stable download URLs for Binary Ninja are not available.
      Please visit ${url} and find the download link for ${name},
      then add it to the Nix store with this command:

        nix-prefetch-url --name ${name} --type sha256 <URL>
    '';
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r * $out/opt
    chmod +x $out/opt/binaryninja

    # https://github.com/Vector35/binaryninja-api/issues/464
    # path confirmed via strace binaryninja &| kg -C10 python
    ln -s ${python310}/lib/libpython3.10.so.1.0 $out/opt/

    mkdir -p $out/share/pixmaps
    cp docs/img/logo.png $out/share/pixmaps/binary-ninja.png

    mkdir -p $out/bin
    makeWrapper $out/opt/binaryninja $out/bin/binaryninja

    runHook postInstall
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
    makeWrapper
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
