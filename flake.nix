{
  description = "Sky's NixOS machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.build-machine.url = "path:./machines/common/build-machine";

  outputs = { self, nixpkgs, home-manager, ... }@attrs: {
    nixosConfigurations.home = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit attrs; };
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
