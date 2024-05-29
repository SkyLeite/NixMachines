{ config, lib, pkgs, ... }: {
  programs.eww = {
    enable = false;
    configDir = ./.;
    package = pkgs.eww;
  };

  xdg.dataFile."hydra" = {
    enable = true;
    executable = true;
    source = ./hydra.sh;
    target = "scripts/hydra";
  };
}
