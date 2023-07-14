{ config, pkgs, lib, ... }:

{
  programs.gBar = {
    enable = true;
    extraConfig = builtins.readFile ./config;
    extraCSS = builtins.readFile ./style.css;
  };

  # As if
  # systemd.user.services.gbar = {
  #   Unit = { Description = "Service responsible for running gBar"; };
  # };
}
