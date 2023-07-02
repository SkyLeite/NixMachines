{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.srb2kart;
  optionsSubmodule = types.submodule {
    options = {

    };
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
        default = 9080;
        description = "Port to run the server one";
      };

      options = {

      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.srb2kart = {
      enable = true;
      unitConfig = {
        Requires = "network-online.target";
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.srb2kart}/bin/srb2kart -dedicated";
      };
    };
  };
}
