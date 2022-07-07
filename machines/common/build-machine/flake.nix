{
  description = "Builds a machine";

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.build-machine;
    packages.x86_64-linux.build-machine =
      let pkgs = import nixpkgs { system = "x86_64-linux"; };
      in pkgs.writeShellScriptBin "build-machine" ''
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild --flake github:SkyLeite/NixMachines/$1 switch
      '';
  };
}
# ${pkgs.nixos-rebuild}/bin/nixos-rebuild --flake github:SkyLeite/NixMachines/$1 switch
