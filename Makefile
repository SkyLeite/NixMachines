vm:
	nixos-rebuild --flake '.#miles' --option extra-builtins-file ./machines/common/extra-builtins.nix build-vm sudo nixos-rebuild --flake '.' switch --allow-unsafe-native-code-during-evaluation

switch:
	sudo nixos-rebuild --flake '.' --option allow-unsafe-native-code-during-evaluation true switch
