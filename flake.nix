{
  description = "Sky's NixOS machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.build-machine.url = "path:./machines/common/build-machine";

  outputs = { self, nixpkgs, home-manager, ... }@attrs: {
    nixosConfigurations.miles = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit attrs; };
      modules = [ ./machines/miles/default.nix ];
    };
  };
}
