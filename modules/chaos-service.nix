{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.chaos;

  chaosServiceModule = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      port = mkOption { type = types.int; };
      caddyOptions = mkOption {
        type = types.str;
        default = "";
      };
    };
  };
in {
  imports = [ ../services/dashy.nix ];

  options = {
    chaos = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Dashy
        '';
      };

      baseUrl = mkOption { type = types.str; };

      services = mkOption { type = with types; attrsOf chaosServiceModule; };
    };
  };

  config = let
    getServiceUrl = name:
      if name != "root" then name + "." + cfg.baseUrl else cfg.baseUrl;

    serviceToVirtualHost = (name: value:
      lib.nameValuePair (getServiceUrl name) ({
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString value.port}
          header Access-Control-Allow-Origin *
        '' + value.caddyOptions;
      }));

    serviceToDashyService = (name: service: {
      title = name;
      url = "https://" + (getServiceUrl name);
    });

    enabledServices =
      lib.filterAttrs (name: value: value.enable == true) cfg.services;

    dashyItems = lib.trivial.pipe enabledServices [
      (lib.mapAttrs serviceToDashyService)
      attrValues
    ];

    virtualHosts = lib.mapAttrs' serviceToVirtualHost enabledServices;
  in mkIf cfg.enable {
    networking = { firewall = { allowedTCPPorts = [ 80 443 ]; }; };

    services.caddy = {
      enable = true;
      email = "sky@leite.dev";

      virtualHosts = virtualHosts;
    };

    services.dashy = {
      config = {
        sections = [{
          name = "Test";
          items = dashyItems;
        }];
      };
    };
  };
}
