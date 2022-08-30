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
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.noisetorch ];

    systemd.user.services.noisetorch = {
      Unit = {
        Description = "Noisetorch Noise Canceling";
        After = "pipewire.service";
      };

      Service = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "3";
        RemainAfterExit = "yes";
        ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -t 95";
        ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };
}
