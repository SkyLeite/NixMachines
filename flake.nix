{
  description = "Sky's NixOS machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nix-colors.url = "github:misterio77/nix-colors";
  inputs.gbar.url = "github:scorpion-26/gBar";
  inputs.srb2nixpkgs.url =
    "github:donovanglover/nixpkgs/97b52a7a806da410d171a755459fba17e39fcfed";
  inputs.nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

  outputs = { self, nixpkgs, home-manager, nix-colors,
      gbar, srb2nixpkgs, nixpkgs-f2k, ...
    }@attrs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      monitors = import ./machines/common/monitor-profiles.nix {
        inherit pkgs;
        inherit (nixpkgs) lib;
      };
    in {

      packages.x86_64-linux.unnamed-sdvx-clone =
        import ./packages/unnamed-sdvx-clone.nix pkgs;

      homeConfigurations.sky = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./users/sky/home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        # extraSpecialArgs = { inherit nix-colors; };
      };

      nixosConfigurations.home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs attrs monitors; };
        modules = [
          {
            nix.settings.substituters = [
              "https://cache.nixos.org?priority=10"
              "https://fortuneteller2k.cachix.org"
            ];

            nix.settings.trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
            ];

            nixpkgs.overlays = [ nixpkgs-f2k.overlays.window-managers ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sky = import ./users/sky/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit nix-colors monitors gbar;
            };
          }
          ./machines/home/default.nix
        ];
      };

      nixosConfigurations.miles = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit attrs; };
        modules = [ ./machines/miles/default.nix ];
      };
    };
}
