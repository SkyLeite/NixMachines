{ config, lib, pkgs, ... }:

with lib; # use the functions from lib, such as mkIf

let
  # the values of the options set for the service by the user of the service
  cfg = config.services.webhook;
in {
  ##### interface. here we define the options that users of our service can specify
  options = {
    # the options for our service will be located under services.webhook
    services.webhook = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable webhooks.
        '';
      };

      ip = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          ip the webhook should serve hooks on
        '';
      };

      port = mkOption {
        type = types.int;
        default = 9000;
        description = ''
          port the webhook should serve hooks on
        '';
      };

      webhooks = mkOption {
        type = types.listOf types.anything;
        default = [ ];
        description = ''
          A list of hooks
        '';
      };

      verbose = mkOption {
        type = types.bool;
        default = false;
        description = "Enable verbose output";
      };
    };
  };

  ##### implementation
  config = mkIf cfg.enable { # only apply the following settings if enabled
    # here all options that can be specified in configuration.nix may be used
    # configure systemd services
    # add system users
    # write config files, just as an example here:

    environment.systemPackages = [ pkgs.webhook ];

    systemd.services.webhook = let
      format = pkgs.formats.json { };
      hooksJson = format.generate "hooks.json" cfg.webhooks;
    in {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart =
        "${pkgs.webhook}/bin/webhook -hooks ${hooksJson} -ip ${cfg.ip} -port ${
          toString cfg.port
        } ${if cfg.verbose == true then "-verbose" else ""}";
    };
  };
}
