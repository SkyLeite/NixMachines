vm:
	nixos-rebuild --flake '.#miles' --option extra-builtins-file ./machines/common/extra-builtins.nix build-vm

switch:
	nixos-rebuild --flake '.' switch
