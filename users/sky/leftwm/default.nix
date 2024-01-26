{ stdenv, config, pkgs, lib, monitors, leftwm, ... }:
let
  i3 = config.xsession.windowManager.i3;
  text = pkgs.callPackage ../../../util/text.nix { };

  configFile = text.templateFile "config.ron" ./config.ron {
    mod = i3.config.modifier;
    terminal = i3.config.terminal;
  };
in {
  home.packages = [ leftwm ];
  home.file = { ".config/leftwm/config.ron" = { source = configFile; }; };
}
