{
  description = "Pagekite";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.pagekite = {
    type = "file";
    url = "https://pagekite.net/pk/pagekite.py";
    flake = false;
  };

  outputs = { self, nixpkgs, pagekite }:
    with import nixpkgs { system = "x86_64-linux"; }; {
      packages.x86_64-linux.pagekite = stdenv.mkDerivation {
        pname = "pagekite";
        version = "0.1.0";

        src = self;

        buildInputs = [ pkgs.python38 ];

        buildPhase = "cp ${pagekite} pagekite";

        installPhase = ''
          mkdir -p $out/bin;
          install pagekite -t $out/bin;
        '';
      };
      defaultPackage.x86_64-linux = self.packages.x86_64-linux.pagekite;
    };
}
