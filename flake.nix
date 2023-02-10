{
  description = "Sky's NixOS machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.mesa-git-src = {
    url =
      "github:chaotic-aur/mesa-mirror/99fb770c4502f36110bd8ba8a8bc0fb810ba76a6";
    flake = false;
  };

  outputs = { self, nixpkgs, home-manager, mesa-git-src, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.sky = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./users/sky/home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };

      nixosConfigurations.home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit nixpkgs;
          inherit attrs;
          inherit mesa-git-src;
        };
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev:
                let sdl2Patched = pkgs.SDL2.override { udevSupport = true; };
                in {
                  # This change makes `udevadm monitor` emit events inside `steam-run
                  # bash`. The bug can be observed *without* this patch by running
                  # `SYSTEMD_LOG_LEVEL=debug udevadm monitor` inside `steam-run bash` and
                  # observing the "sd-device-monitor: Sender uid=N, message ignored"
                  # messsage. However, it doesn't make *steam* detect devices
                  # dynamically.
                  steam = prev.steam.override {
                    extraPkgs = pkgs: [ sdl2Patched ];
                    extraLibraries = pkgs: [ sdl2Patched ];
                  };
                })
            ];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sky = import ./users/sky/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
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
