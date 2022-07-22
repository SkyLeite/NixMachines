{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.n8n;
in {
  imports = [ ../modules/chaos-service.nix ];

  config = mkIf cfg.enable {
    chaos.services.n8n = {
      enable = true;
      port = 5678;
    };

    services.n8n = {
      settings = {
        DOMAIN_NAME = config.chaos.baseUrl;
        SUBDOMAIN = "n8n";
      };
    };
  };
}
