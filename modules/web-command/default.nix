{ pkgs, lib, config, ... }:
with lib;

let
  cfg = config.services.web-command;

  server = import ./server/default.nix { inherit pkgs; };

  commandModule = types.submodule {
    options = {
      command = mkOption {
        type = types.str;
        description = "Bash command to be ran";
      };

      title = mkOption {
        type = types.str;
        description = "Title for the command to be ran";
      };
    };
  };
in {
  options.services.web-command = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    commands = mkOption { type = types.listOf commandModule; };
  };

  config = mkIf cfg.enable {
    environment.etc."web-command.json" = {
      text = builtins.toJSON cfg.commands;
    };

    systemd.services.web-command = {
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;
      restartIfChanged = true;
      after = [ ];
      requires = [ ];
      preStop = "killall web-command.py";
      serviceConfig = {
        TimeoutStartSec = 0;
        TimeoutStopSec = 120;
        Restart = "always";
        ExecStart = "${server}/bin/run";
      };
    };
  };
}
