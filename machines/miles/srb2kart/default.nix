{ config, pkgs, lib, ... }:
let filesPath = ./files;
in {
  imports =
    [ ../../../modules/chaos-service.nix ../../../modules/srb2kart.nix ];

  services.srb2kart = {
    enable = true;
    config = {
      files = lib.filesystem.listFilesRecursive filesPath;
      clientConfig = ''
        http_source "kart.zerolab.app"
        advertise On
        karteliminatelast No
      '';
    };
  };

  chaos.services.kart = {
    enable = true;
    port = 7483;
    caddyOptions = ''
      root * ${filesPath}
      file_server browse
    '';
  };
}
