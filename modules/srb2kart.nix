{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.srb2kart;
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
    services.srb2kart = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable SRB2Kart server";
      };

      port = mkOption {
        type = types.int;
        default = 5029;
        description = "Port to run the server one";
      };

      package = mkOption {
        type = types.package;
        description = "srb2kart package to use";
        default = pkgs.srb2kart;
      };

      config = mkOption {
        type = configSubmodule;
        default = defaultConfig;
      };
    };
  };

  config = mkIf cfg.enable {

    environment.etc.srb2kart = {
      target = "srb2kart/.srb2kart/kartserv.cfg";
      text = cfg.config.clientConfig;
    };

    systemd.services.srb2kart = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        Requires = "network-online.target";
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/srb2kart -dedicated ${
            if length cfg.config.files > 0 then
              "-file ${toString cfg.config.files}"
            else
              ""
          }";
      };
      environment = { HOME = "/etc/srb2kart"; };
    };

    networking = {
      firewall = {
        allowedUDPPorts = [ cfg.port ];
        allowedTCPPorts = [ cfg.port ];
      };
    };
  };
}
