{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.wrappedN8n;
in {
  imports = [ ../modules/chaos-service.nix ];

  options = {
    services.wrappedN8n = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable N8n
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    chaos.services.n8n = {
      enable = true;
      port = 5678;
    };

    systemd.services.n8n = {
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;
      restartIfChanged = true;
      after = [ "docker.service" "docker.socket" ];
      requires = [ "docker.service" "docker.socket" ];
      preStop = "${pkgs.docker}/bin/docker stop n8n";
      reload = "${pkgs.docker}/bin/docker restart n8n";
      serviceConfig = {
        ExecStartPre = "-${pkgs.docker}/bin/docker rm -f n8n";
        ExecStopPost = "-${pkgs.docker}/bin/docker rm -f n8n";
        TimeoutStartSec = 0;
        TimeoutStopSec = 120;
        Restart = "always";
        ExecStart = ''
          ${pkgs.docker}/bin/docker run \
            --rm \
            --name=n8n \
            --network=host \
            -e WEBHOOK_URL=n8n.${config.chaos.baseUrl} \
            -v /srv/n8n/config:/home/node/.n8n \
            n8nio/n8n:latest
        '';
      };
    };
  };
}
