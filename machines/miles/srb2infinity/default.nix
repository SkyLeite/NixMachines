{ config, pkgs, lib, srb2pkgs, ... }:
let filesPath = ./files;
in {
  imports =
    [ ../../../modules/chaos-service.nix ../../../modules/srb2.nix ];

  services.srb2 = {
    enable = true;
    package = srb2pkgs.srb2;
    port = 6767;
    config = {
      files = lib.filesystem.listFilesRecursive filesPath;
      clientConfig = ''
        http_source "srb2infinity.zerolab.app"
        advertise On
        servername "Dr. Zap - discord.gg/invite/r-br"
        server_contact "sky@leite.dev"
      '';
    };
  };

  chaos.services.srb2infinity = {
    enable = true;
    port = 6767;
    caddyOptions = ''
      root * ${filesPath}
      file_server browse
    '';
  };
}
