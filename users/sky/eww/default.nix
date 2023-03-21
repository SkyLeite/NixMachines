{ config, lib, pkgs, ... }: {
  programs.eww = {
    enable = true;
    configDir = ./.;
    package = pkgs.eww-wayland;
  };

  xdg.dataFile."hydra" = {
    enable = true;
    executable = true;
    source = ./hydra.sh;
    target = "scripts/hydra";
  };
}
