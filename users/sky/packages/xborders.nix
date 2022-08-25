{ pkgs, ... }:

let
  xborders = pkgs.stdenv.mkDerivation {
    name = "xborders";
    nativeBuildInputs = [ pkgs.wrapGAppsHook ];

    propagatedBuildInputs = with pkgs; [
      libwnck
      gtk3
      gobject-introspection
      (pkgs.python310.withPackages (python-packages:
        with python-packages; [
          pycairo
          pygobject3
          requests
        ]))
    ];

    src = pkgs.fetchFromGitHub {
      owner = "deter0";
      repo = "xborders";
      rev = "fa50c9040c61e4ce17b2ada4de3b4a0e215e087a";
      sha256 = "sha256-Mrt5cm3z4Qt5trPoLLgKJaA88O/z0GYGNI7NaaPULCY=";
    };

    installPhase = ''
      mkdir -p $out/bin
      cp xborders $out/bin
    '';

    shellHook = ''
      MPLBACKEND=GTK3Cairo exec python
    '';
  };
in {
  home.packages = [ xborders ];

  systemd.user.services = {
    xborders = {
      Unit = {
        Description = "xborders";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart =
          "${xborders}/bin/xborders --disable-version-warning --border-radius 10 --border-width 3";
        Restart = "always";
        RestartSec = 10;
      };

      Install = { WantedBy = [ "multi-user.target" ]; };
    };
  };
}
