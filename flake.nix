{
  description = "Sky's NixOS machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nix-colors.url = "github:misterio77/nix-colors";
  inputs.hyprland = {
    url = "github:hyprwm/Hyprland";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.hyprland-contrib.url = "github:hyprwm/contrib";
  inputs.gbar.url = "github:scorpion-26/gBar";
  inputs.srb2knixpkgs.url = "github:MGlolenstine/nixpkgs/srb2kart";
  inputs.srb2nixpkgs.url =
    "github:donovanglover/nixpkgs/97b52a7a806da410d171a755459fba17e39fcfed";

  outputs = { self, nixpkgs, home-manager, nix-colors, hyprland
    , hyprland-contrib, gbar, srb2knixpkgs, srb2nixpkgs, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      srb2kartpkgs = srb2knixpkgs.legacyPackages.${system};
      srb2pkgs = srb2nixpkgs.legacyPackages.${system};
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
        specialArgs = { inherit nixpkgs attrs monitors srb2kartpkgs srb2pkgs; };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sky = import ./users/sky/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit nix-colors hyprland hyprland-contrib monitors gbar;
            };
          }
          ./machines/home/default.nix
        ];
      };

      nixosConfigurations.miles = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit attrs srb2kartpkgs srb2pkgs; };
        modules = [ ./machines/miles/default.nix ];
      };
    };
}
