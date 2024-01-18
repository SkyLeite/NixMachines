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
    users.groups.srb2kart = { };
    users.extraUsers.srb2kart = {
      isNormalUser = false;
      group = "srb2kart";
      home = "/etc/srb2kart";
      createHome = false;
      useDefaultShell = true;
      isSystemUser = true;
      description = "User for the SRB2Kart service";

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb5TDxcYY8vE/zAcFwvLYtpDAUAuK6UDt3MPG1KXPoHckjeZcSmIdzhjuNRZz7MI47Gp1Pz58rUkB19b1gtIV5omu22hn0qhPVjAXOO0qd9cARy+7/Prh27b6rQ/a9qhtUjoDZkiOM7ycDBP0H0UiQQCjQqGsEZi54azvpX1lganzBfIV0atcwn2DZC2xerz0qRVMjjH3I7Gg2Kn75WzJgT+RmdY6W/4bOqh2/8Yg8sx4e1m7YjVAdQe3+5DoYuvQwcXL7glCQMyPWw4fDr8MBAjR34DFeCGd+9IhnUIvxwyrrfyeMufpLPXkvuh9YFcsQGte1fhcCfkhLCzdC/h2FJkfFAqsDvmumY3ipXyloSBAp7fpVYSJcIQYabuP+qUVUgOrXVvpMamdnTKVg/YeNsc8XC0mhSYXoc099+e7FMqq8JcOrcroeBqJiDQBpkx8UAX9DUSREp4f3IwATDt9ZP5kHrzmZZrJGNKpQcqObZRzp2u0eDnFgp0Uf098EEmk= sapo@sv-primario"
      ];
    };

    environment.etc.srb2kart = {
      target = "srb2kart/.srb2kart/kartserv.cfg";
      text = cfg.config.clientConfig;
      user = "srb2kart";
      group = "srb2kart";
      mode = "0770";
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
