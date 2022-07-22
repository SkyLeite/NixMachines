{ writeShellScriptBin, pkgs, stdenv }:
let
  wrapper = writeShellScriptBin "build-machine" ''
    ${pkgs.nixos-rebuild}/bin/nixos-rebuild \
          --flake github:SkyLeite/NixMachines/$1 \
          --option extra-builtins-file ./extra-builtins.nix \
          switch'';
in stdenv.mkDerivation {
  name = "build-machine";
  dontUnpack = true;
  src = wrapper;

  installPhase = ''
    install -D ${wrapper}/bin/build-machine -t $out/bin
  '';
}
