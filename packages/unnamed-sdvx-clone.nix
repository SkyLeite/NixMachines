{ stdenv, writeShellScriptBin, fetchFromGitHub, makeDesktopItem, cmake, freetype
, libogg, libvorbis, SDL2, zlib, libpng, libjpeg, libarchive, libGL, mesa
, openssl, libiconv, git, zlib-ng, rapidjson, curl, libcpr, ... }:

stdenv.mkDerivation {
  name = "Unnamed SDVX Clone";

  src = fetchFromGitHub {
    owner = "SkyLeite";
    repo = "unnamed-sdvx-clone";
    rev = "861fc14ab013cd88326192d834c523f03d004b32";
    sha256 = "sha256-fh7DgWzAClT+nKqbAS4xkx76jxKg5mZmBdU2jO8AIOg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    rapidjson
    cmake
    curl
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
    "-DUSE_SYSTEM_CPR=ON"
    "-DCPR_INCLUDE_PATH=${libcpr}/include"
    "-DGIT_COMMIT=b244b4ba2d22b73622f08541d5b038b136c36614"
  ];

  desktopItem = makeDesktopItem {
    name = "Unnamed SDVX Clone";
    exec = "usc-game";
    comment = "Unnamed SDVX Clone";
    desktopName = "Unnamed SDVX Clone";
    categories = [ "Game" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    ln -s "$desktopItem/share/applications" "$out/share/"

    mkdir -p $out/bin
    cp -r ../bin $out

    runHook postInstall
  '';
}
