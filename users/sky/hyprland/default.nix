{ config, pkgs, lib, hyprland-contrib, ... }:

{
  home.packages = [ hyprland-contrib.packages.${pkgs.system}.grimblast ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = builtins.replaceStrings [ "@@kb_file@@" ]
      [ (builtins.toString ../us-br.xkb) ] (builtins.readFile ./hyprland.conf);
  };
}
