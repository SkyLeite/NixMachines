{
  description = "Sky's NixOS machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, home-manager, ... }@attrs: {
    nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit attrs; };
      modules = [ ./machines/home-server/default.nix ];
    };
  };
}
