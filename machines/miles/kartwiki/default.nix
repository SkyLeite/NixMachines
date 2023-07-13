{ config, pkgs, lib, srb2kartpkgs, ... }:
let port = 7483;
in {
  services.mediawiki = {
    enable = true;

    url = "https://kartwiki.zerolab.app";
    name = "SRB2Kart";

    passwordFile = "/run/keys/mediawiki-password";
    passwordSender = "sky@leite.dev"; # lmao

    database = {
      user = "mediawiki";
      name = "mediawiki";

      type = "postgres";

      socket = "/run/postgresql";
      createLocally = false;
    };

    httpd.virtualHost = {
      listen = [{
        ip = "*";
        port = port;
        ssl = false;
      }];
    };

    extensions = {
      TinyMCE = pkgs.fetchzip {
        url =
          "https://github.com/wikimedia/mediawiki-extensions-TinyMCE/archive/f2a3fbedd5dba81552de513716cd8697b8ff93fe.zip";
        sha256 = "sha256-+fAEcUwmEqqljsNevqNGNdhH+0h8Ku+EvJDMEjKCI/w=";
      };
    };

    extraConfig = ''
      wfLoadExtension('TinyMCE');
      $wgTinyMCEEnabled = true;
    '';
  };

  services.phpfpm.settings = { log_level = "error"; };

  services.postgresql = {
    ensureDatabases = [ "mediawiki" ];
    ensureUsers = [{
      name = "mediawiki";
      ensurePermissions = {
        "DATABASE \"mediawiki\"" = "ALL PRIVILEGES";
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
