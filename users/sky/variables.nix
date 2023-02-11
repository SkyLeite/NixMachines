{ config, lib, ... }:

with lib;
let cfg = config.variables;
in {
  options.variables = {
    wallpaper = mkOption {
      type = types.path;
      description = "Path to the wallpaper file to use";
    };

    colorScheme = mkOption {
      type = types.attrs;
      description = "A colorscheme from nix-colors to use";
    };
  };

  config = { colorScheme = cfg.colorScheme; };
}
