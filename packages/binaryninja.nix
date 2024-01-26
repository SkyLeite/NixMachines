{ stdenv, lib, buildFHSEnv, writeScript, makeDesktopItem, pkgs }:
let
  buildInputs = pkgs:
    with pkgs; [
      dbus
      fontconfig
      freetype
      libGL
      libxkbcommon
      python3
      xorg.libX11
      xorg.libxcb
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      wayland
      zlib
      gdb
      lldb
      stdenv.cc.cc.lib
    ];

  fhs = buildFHSEnv {
    name = "binaryninja";
    targetPkgs = buildInputs;

    runScript = writeScript "binaryninja.sh" ''
      export LD_LIBRARY_PATH="${
        lib.makeLibraryPath (buildInputs pkgs)
      }:$LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="${stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH"

      set -e
      exec "$HOME/BinaryNinja/binaryninja"
    '';

    meta = {
      description = "BinaryNinja";
      platforms = [ "x86_64-linux" ];
    };
  };

in stdenv.mkDerivation {
  name = "fhs-env-derivation";

  dontUnpack = true;

  nativeBuildInputs = [ fhs ];

  desktopItem = makeDesktopItem {
    name = "Binary Ninja";
    exec = "${fhs}/bin/binaryninja";
    comment = "Binary Ninja";
    desktopName = "Binary Ninja";
    categories = [ "Game" ];
  };

  installPhase = ''
    mkdir --parent $out
    mkdir --parent $out/share

    echo 'fhs: ${fhs}'
    ls -la ${fhs}

    ln -s "$desktopItem/share/applications" $out/share/
    cp -r ${fhs} $out/binaryninja
  '';
}
