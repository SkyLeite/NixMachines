{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.papermc;
in {
  options = {
    services.papermc = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Papermc
        '';
      };

      config = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Papermc's global configuration
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    chaos.services.root = {
      enable = true;
      port = 8080;
    };

    systemd.services.papermc = let
      format = pkgs.formats.yaml { };
      config = format.generate "papermc.yml" cfg.config;
    in {
      description = "Minecraft Server";
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true;
      requires = [ "network-online.target" ];
      serviceConfig = {
        User = "minecraft";
        Nice = 1;
        KillMode = "none";
        WorkingDirectory = "/opt/minecraft/server";
        ExecStart = "${pkgs.papermc}/bin/minecraft-server";
        TimeoutStartSec = 0;
        TimeoutStopSec = 120;
        Restart = "always";
      };
    };
  };
}
