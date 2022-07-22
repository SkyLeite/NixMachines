vm:
	nixos-rebuild --flake '.#miles' --option extra-builtins-file ./machines/common/extra-builtins.nix build-vm
