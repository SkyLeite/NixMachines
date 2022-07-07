{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.dashy;
in {
  options = {
    services.dashy = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable webhooks.
        '';
      };

      config = mkOption {
        type = types.anything;
        default = { };
        description = ''
          A list of hooks
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.dashy = let
      format = pkgs.formats.yaml { };
      config = format.generate "dashy.yml" cfg.config;
    in {
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;
      restartIfChanged = true;
      after = [ "docker.service" "docker.socket" ];
      requires = [ "docker.service" "docker.socket" ];
      preStop = "${pkgs.docker}/bin/docker stop dashy";
      reload = "${pkgs.docker}/bin/docker restart dashy";
      serviceConfig = {
        ExecStartPre = "-${pkgs.docker}/bin/docker rm -f dashy";
        ExecStopPost = "-${pkgs.docker}/bin/docker rm -f dashy";
        TimeoutStartSec = 0;
        TimeoutStopSec = 120;
        Restart = "always";
        ExecStart = ''
          ${pkgs.docker}/bin/docker run \
            -p 8080:80 \
            --rm \
            --name=dashy \
            --network=host \
            -v ${config}:/app/public/conf.yml \
            lissy93/dashy:latest
        '';
      };
    };
  };
}
