{ writeShellScriptBin, pkgs, stdenv }:
let
  wrapper = writeShellScriptBin "build-machine" ''
    ${pkgs.nixos-rebuild}/bin/nixos-rebuild \
          --flake github:SkyLeite/NixMachines/$1 \
          --option extra-builtins-file ./extra-builtins.nix \
          --option allow-unsafe-native-code-during-evaluation true \
          switch && \
          nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -n 1 | tee /tmp/current-generation;

  '';
in stdenv.mkDerivation {
  name = "build-machine";
  dontUnpack = true;
  src = wrapper;

  installPhase = ''
    install -D ${wrapper}/bin/build-machine -t $out/bin
  '';
}
