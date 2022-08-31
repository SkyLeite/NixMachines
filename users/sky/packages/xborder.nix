{ pkgs, ... }:

let
  xborder = pkgs.stdenv.mkDerivation {
    name = "xborder";
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
      repo = "xborder";
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
  home.packages = [ xborder ];

  systemd.user.services = {
    xborder = {
      Unit = {
        Description = "xborder";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart =
          "${xborder}/bin/xborders --disable-version-warning --border-radius 10 --border-width 3";
        Restart = "always";
        RestartSec = 10;
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };
}
