{ pkgs, ... }:

pkgs.fetchurl {
  url =
    "https://raw.githubusercontent.com/SkyLeite/rofi-libvirt/master/rofi-libvirt.py?123";
  sha256 = "sha256-N4mv6FXYICERW7gru4SbpUll3SxZDi6gXj2yDwdu4gg=";
  executable = true;
}
