{ config, pkgs, lib, srb2kartpkgs, ... }:
let port = 7483;
in {
  services.mediawiki = {
    enable = true;

    url = "kartwiki.zerolab.app";
    name = "SRB2Kart";

    passwordFile = "/run/keys/mediawiki-password";

    database = {
      user = "mediawiki";
      name = "mediawiki";

      type = "postgres";

      host = "localhost";
      port = config.services.postgresql.port;
    };

    httpd.virtualHost = {
      listen = [{
        ip = "*";
        port = port;
        ssl = false;
      }];
    };
  };

  services.postgresql = {
    ensureDatabases = [ "mediawiki" ];
    ensureUsers = [{
      name = "nocodb";
      ensurePermissions = {
        "DATABASE \"db\"" = "ALL PRIVILEGES";
        "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
      };
      ensureClauses.login = true;
    }];
  };

  chaos.services.kartwiki = {
    enable = true;
    port = port;
  };
}
