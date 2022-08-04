{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.funkwhale;
  postgresCfg = config.services.postgresql;
  postgresPort = postgresCfg.port;
  staticFiles = pkgs.stdenv.mkDerivation {
    name = "funkwhale-front";
    src = ./front;
    installPhase = ''
      mkdir $out
      cp -rv $src/* $out
    '';
  };
in {
  imports = [ ../../modules/chaos-service.nix ];

  options = {
    services.funkwhale = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable N8n
        '';
      };

      version = mkOption {
        type = types.str;
        default = "1.2.7";
      };
    };
  };

  config = mkIf cfg.enable {
    chaos.services.funkwhale = {
      enable = true;
      port = 5000;
      addToCaddy = false;
    };

    services.redis = {
      servers.funkwhale = {
        enable = true;
        user = "redis-funkwhale";
        port = 6397;
      };
    };

    services.caddy = {
      virtualHosts = {
        "funkwhale.zerolab.app" = {
          extraConfig = ''
            header Access-Control-Allow-Origin *
            reverse_proxy /api 127.0.0.1:5000
            root * ${staticFiles}/dist
            file_server
          '';
        };

        # "funkwhale.zerolab.app/api" = {
        #   extraConfig = ''
        #     reverse_proxy 127.0.0.1:5000
        #     header Access-Control-Allow-Origin *
        #   '';
        # };
      };
    };

    services.postgresql = {
      enable = true;
      port = 5432;
      ensureUsers = [{
        name = "funkwhale";
        ensurePermissions = {
          "DATABASE \"funkwhale\"" = "ALL PRIVILEGES";
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }];
      ensureDatabases = [ "funkwhale" ];
    };

    virtualisation.oci-containers.containers = {
      celeryworker = {
        image = "funkwhale/funkwhale:${cfg.version}";
        environment = { "C_FORCE_ROOT" = "true"; };
        entrypoint =
          "celery -A funkwhale_api.taskapp worker -l INFO --concurrency=4";
        environmentFiles = [ ./.env ];
      };

      celerybeat = {
        image = "funkwhale/funkwhale:${cfg.version}";
        entrypoint = "celery -A funkwhale_api.taskapp beat --pidfile= -l INFO";
        environmentFiles = [ ./.env ];
      };

      api = {
        image = "funkwhale/funkwhale:${cfg.version}";
        ports = [ "5050" ];
        volumes = [ "/srv/funkwhale/data/music:/music:ro" ];
        environmentFiles = [ ./.env ];
      };
    };
  };
}
