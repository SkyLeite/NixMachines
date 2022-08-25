{ stdenv, lib, pkgs, makeWrapper, ... }:
stdenv.mkDerivation {
  pname = "rofi-firefox";
  version = "08049f6";
  src = pkgs.writeShellScriptBin "rofi-firefox"
    (builtins.readFile ./rofi-firefox.sh);
  buildInputs = [ pkgs.bash pkgs.jq pkgs.dbus ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp bin/rofi-firefox $out/bin/rofi-firefox.sh
    wrapProgram $out/bin/rofi-firefox.sh \
      --prefix PATH : ${lib.makeBinPath [ pkgs.bash pkgs.jq pkgs.dbus ]}
  '';
}
