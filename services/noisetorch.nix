{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.noisetorch;
in {
  options = {
    services.noisetorch = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Noisetorch service
        '';
      };

      unit = mkOption {
        type = types.str;
        description = "The systemd unit for the device";
      };

      id = mkOption {
        type = types.str;
        description = "The id for the device";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.noisetorch = {
      description = "Noisetorch Noise Canceling";
      after = [ "pipewire.service" cfg.unit ];
      requires = [ cfg.unit ];
      serviceConfig = {
        Type = "simple";
        User = "sky";
        Restart = "on-failure";
        RestartSec = "3";
        RemainAfterExit = "yes";
        ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -s ${cfg.id} -t 95";
        ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
      };
    };
  };
}
