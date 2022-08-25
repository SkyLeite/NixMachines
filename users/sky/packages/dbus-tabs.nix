{ pkgs, stdenv, ... }:

stdenv.mkDerivation {
  name = "dbus-tabs";
  propagatedBuildInputs = with pkgs;
    [
      (pkgs.python310.withPackages (python-packages:
        with python-packages; [
          pygobject3
          pydbus
          dbus-python
        ]))
    ];

  src = pkgs.fetchFromGitHub {
    owner = "cubimon";
    repo = "dbus-tabs";
    rev = "a6d3b0665b44e619ba2ec88801f2349a39bd1bad";
    sha256 = "sha256-/1aQ/eowjUxDLi3TyxUjBjSJxAHnEbh6JWsvcgmCeIk=";
  };

  installPhase = ''
    cp -r . $out
  '';
}
