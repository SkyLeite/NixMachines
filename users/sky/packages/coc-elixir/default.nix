with (import <nixpkgs> { }); {
  coc-elixir = yarn2nix.mkYarnPackage {
    name = "coc-elixir";
    src = pkgs.fetchFromGitHub {
      owner = "elixir-lsp";
      repo = "coc-elixir";
      rev = "0550cd66834d05963dd20ede99c047f85382ce45";
      sha256 = "13l4qfnbwza89cd708dmy9fa3df8mbr9b93vakkgm2n6kc3a3nzy";
      fetchSubmodules = true;
    };
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
  };
}
