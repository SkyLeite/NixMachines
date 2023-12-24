{ stdenv, writeShellScriptBin, fetchFromGitHub, makeDesktopItem, cmake, freetype
, libogg, libvorbis, SDL2, zlib, libpng, libjpeg, libarchive, libGL, mesa
, openssl, libiconv, git, zlib-ng, libcpr, rapidjson, ... }:
let
  pkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "my-old-revision";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "77294205ac81810f333e25da2eb876d348fd7edc";
  }) { };

  curl_7_55 = pkgs.curlFull;
in stdenv.mkDerivation {
  name = "Unnamed SDVX Clone";

  src = fetchFromGitHub {
    owner = "Drewol";
    repo = "unnamed-sdvx-clone";
    rev = "b244b4ba2d22b73622f08541d5b038b136c36614";
    sha256 = "sha256-cTNyM+CfnEvxjfM9FKMgN8khLxUcU4H04BS3T4TiPhU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    rapidjson
    cmake
    curl_7_55
    zlib-ng
    freetype
    libogg
    libvorbis
    SDL2
    zlib
    libpng
    libjpeg
    libarchive
    libcpr
    libGL
    mesa
    openssl
    libiconv
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCPR_USE_SYSTEM_CURL=ON"
    "-DCPR_FORCE_USE_SYSTEM_CURL=ON"
    "-DUSC_GNU_WERROR=Off"
    "-DGIT_COMMIT=b244b4ba2d22b73622f08541d5b038b136c36614"
  ];

  wrapperScript = writeShellScriptBin "usc-game-wrapped" ''
    DATA_PATH=$HOME/.config/usc

    mkdir -p $DATA_PATH

    cp -r @out@/bin/audio $DATA_PATH
    cp -r @out@/bin/fonts $DATA_PATH
    cp -r @out@/bin/skins $DATA_PATH
    cp -r @out@/bin/LightPlugins $DATA_PATH

    @out@/bin/usc-game -gamedir="$DATA_PATH"
  '';

  desktopItem = makeDesktopItem {
    name = "Unnamed SDVX Clone";
    exec = "usc-game-wrapped";
    comment = "Unnamed SDVX Clone";
    desktopName = "Unnamed SDVX Clone";
    categories = [ "Game" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    substituteAll $wrapperScript/bin/usc-game-wrapped $out/bin/usc-game-wrapped
    chmod +x $out/bin/usc-game-wrapped

    mkdir $out/share
    ln -s "$desktopItem/share/applications" "$out/share/"

    cp -r /build/source/bin $out

    runHook postInstall
  '';
}
