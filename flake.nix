{
  description = "Sky's NixOS machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nix-colors.url = "github:misterio77/nix-colors";
  inputs.hyprland.url = "github:hyprwm/Hyprland";

  outputs = { self, nixpkgs, home-manager, nix-colors, hyprland, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      monitors = import ./machines/common/monitor-profiles.nix {
        inherit pkgs;
        inherit (nixpkgs) lib;
      };
    in {
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
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sky = import ./users/sky/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit nix-colors hyprland monitors;
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
