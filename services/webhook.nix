{ config, lib, pkgs, ... }:

with lib; # use the functions from lib, such as mkIf

let
  # the values of the options set for the service by the user of the service
  webhookcfg = config.services.webhook;
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

      ip = {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          ip the webhook should serve hooks on
        '';
      };

      port = {
        type = types.int;
        default = 9000;
        description = ''
          port the webhook should serve hooks on
        '';
      };

      webhooks = {
        type = types.listOf types.attrsOf types.anything;
        default = [ ];
        description = ''
          A list of hooks
        '';
      };
    };
  };

  ##### implementation
  config =
    mkIf webhookcfg.enable { # only apply the following settings if enabled
      # here all options that can be specified in configuration.nix may be used
      # configure systemd services
      # add system users
      # write config files, just as an example here:

      environment.systemPackages = [ pkgs.webhook ];

      systemd.services.webhook = let
        format = pkgs.formats.json { };
        hooksJson = format.generate "hooks.json" webhookcfg.webhooks;
      in {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart =
          "${pkgs.webhook}/bin/webhook -hooks ${hooksJson} -ip ${webhookcfg.ip} -port ${webhookcfg.port}";
      };
    };
}