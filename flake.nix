{
  description = "Sky's NixOS machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.pagekite.url = "path:./packages/pagekite";

  outputs = { self, nixpkgs, home-manager, ... }@attrs: {
    nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit attrs; };
      modules = [ ./machines/home-server/default.nix ];
    };

    # packages.x86_64-linux.pagekite = import ./packages/pagekite/flake.nix;
  };
}
