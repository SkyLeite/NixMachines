{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.srb2;
  configSubmodule = types.submodule {
    options = {
      files = mkOption {
        type = types.listOf (types.path);
        description = "List of files to be used in the server";
        default = [ ];
      };

      clientConfig = mkOption {
        type = types.lines;
        description = "Lines to be added to the config file";
        default = "";
      };
    };
  };

  defaultConfig = {
    files = [ ];
    clientConfig = "";
  };
in {
  options = {
    services.srb2 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable SRB2 server";
      };

      port = mkOption {
        type = types.int;
        default = 5029;
        description = "Port to run the server one";
      };

      package = mkOption {
        type = types.package;
        description = "srb2 package to use";
        default = pkgs.srb2;
      };

      config = mkOption {
        type = configSubmodule;
        default = defaultConfig;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc.srb2 = {
      target = "srb2/.srb2/config.cfg";
      text = cfg.config.clientConfig;
    };

    systemd.services.srb2 = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        Requires = "network-online.target";
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/srb2 -dedicated -serverport ${
            toString cfg.port
          } -room 28 ${
            if length cfg.config.files > 0 then
              "-file ${toString cfg.config.files}"
            else
              ""
          }";
      };
      environment = { HOME = "/etc/srb2"; };
    };

    networking = {
      firewall = {
        allowedUDPPorts = [ cfg.port ];
        allowedTCPPorts = [ cfg.port ];
      };
    };
  };
}
