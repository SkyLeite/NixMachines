{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.nocodb;
in {
  imports = [ ../modules/chaos-service.nix ];

  options = {
    services.nocodb = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Nocodb
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    chaos.services.nocodb = {
      enable = true;
      port = 8070;
    };

    virtualisation.oci-containers.containers = {
      nocodb = {
        image = "nocodb/nocodb:0.108.1";
        autoStart = true;
        ports = [ "8070:8070" ];
        volumes = [ "nc_data:/srv/nocodb/data" ];
        environment = {
          NC_DB = "postgresql://nocodb@localhost:5432/db";
          PORT = "8070";
        };
        extraOptions = [ "--network=host" ];
      };
    };
  };
}
