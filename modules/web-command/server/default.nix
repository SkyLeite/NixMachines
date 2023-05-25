{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "web-command";

  src = ./.;

  buildInputs =
    [ (pkgs.python310.withPackages (ps: [ pkgs.python310Packages.flask ])) ];

  nativeBuildInputs = [ pkgs.which ];

  installPhase = ''
    mkdir -p $out

    cp -r bin $out
    chmod +x $out/bin/run

    substituteInPlace \
      $out/bin/run \
      --replace python $(which python)

    cp web-command.py $out
    cp -r templates $out
  '';
}
