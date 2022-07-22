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
    serviceToVirtualHost = (name: value:
      lib.nameValuePair
      (if name != "root" then name + "." + cfg.baseUrl else cfg.baseUrl) ({
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString value.port}
          header Access-Control-Allow-Origin *
        '' + value.caddyOptions;
      }));

    enabledServices =
      lib.filterAttrs (name: value: value.enable == true) cfg.services;

    virtualHosts = lib.mapAttrs' serviceToVirtualHost enabledServices;
  in mkIf cfg.enable {
    networking = { firewall = { allowedTCPPorts = [ 80 443 ]; }; };

    services.caddy = {
      enable = true;
      email = "sky@leite.dev";

      virtualHosts = virtualHosts;
    };
  };
}
