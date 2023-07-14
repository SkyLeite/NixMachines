vm:
	nixos-rebuild --flake '.#miles' --option extra-builtins-file ./machines/common/extra-builtins.nix build-vm 

switch:
	sudo nixos-rebuild --flake '.' --option allow-unsafe-native-code-during-evaluation true switch
