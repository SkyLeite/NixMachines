{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.papermc;
  mcVersion = "1.20.1";
  buildNum = "72";

  papermc = pkgs.papermc.overrideAttrs (finalAttrs: previousAttrs: {
    version = "1.20.1";

    jar = pkgs.fetchurl {
      url =
        "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
      sha256 = "sha256-VEoqK/APcHRaYoa/w0ROSefUG3VvfeURAXOin3Icgtk=";
    };
  });
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
    networking = { firewall = { allowedTCPPorts = [ 25565 ]; }; };

    systemd.services.papermc = let
      format = pkgs.formats.yaml { };
      config = format.generate "papermc.yml" cfg.config;
    in {
      description = "Minecraft Server";
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true;
      requires = [ "network-online.target" ];
      serviceConfig = {
        Nice = 1;
        StateDirectory = "papermc-server";
        WorkingDirectory = "/srv/minecraft-server";
        ExecStart =
          "${papermc}/bin/minecraft-server -Xms10G -Xmx10G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
        TimeoutStartSec = 0;
        TimeoutStopSec = 120;
        Restart = "always";
      };
    };
  };
}
