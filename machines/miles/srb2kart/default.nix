{ config, pkgs, lib, srb2kartpkgs, ... }:
let filesPath = ./files;
in {
  imports =
    [ ../../../modules/chaos-service.nix ../../../modules/srb2kart.nix ];

  services.srb2kart = {
    enable = true;
    package = srb2kartpkgs.srb2kart;
    config = {
      files = lib.filesystem.listFilesRecursive filesPath;
      clientConfig = ''
        http_source "kart.zerolab.app"
        advertise On
        karteliminatelast No
        kartspeed 2
        servername "Dr. Zap - discord.gg/invite/r-br"
        server_contact "sky@leite.dev"

        hm_specbomb On
        hm_specbomb_antisoftlock On
        hm_timelimit 5
        hm_bail On
        hm_motd On
        hm_motd_nag Off

        hm_motd_name "Dr. Zap"
        hm_motd_contact "\134discord.gg/invite/r-br"
        hm_motd_tagline "Suco de múmia"

        hm_restat On
        hm_restat_notify On
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
