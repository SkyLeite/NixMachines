{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.srb2;
  configSubmodule = types.submodule {
    options = {
      files = mkOption {
        type = types.listOf (types.path);
        description = "List of files to be used in the server";
        default = [ ];
      };

      clientConfig = mkOption {
        type = types.lines;
        description = "Lines to be added to the config file";
        default = "";
      };
    };
  };

  defaultConfig = {
    files = [ ];
    clientConfig = "";
  };
in {
  options = {
    services.srb2 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable SRB2 server";
      };

      port = mkOption {
        type = types.int;
        default = 5029;
        description = "Port to run the server one";
      };

      package = mkOption {
        type = types.package;
        description = "srb2 package to use";
        default = pkgs.srb2;
      };

      config = mkOption {
        type = configSubmodule;
        default = defaultConfig;
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.srb2 = { };
    users.extraUsers.srb2 = {
      isNormalUser = false;
      group = "srb2";
      home = "/etc/srb2";
      createHome = false;
      useDefaultShell = true;
      isSystemUser = true;
      description = "User for the SRB2 service";

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwRAmo21nhKK0vtVUb9qycqlbIjeR9UF0Y04D0c6hjXR8Vp2f5jq+fQZERsowV/c6RsOA25JS/wHLMB3QsSJeZzxYfpKsflbTe5zx1V1phOAfBCxQgDd3jZ5yyWqfP9VnyFqrY6g1pD7BhbgDTCNZirzKHv6FSnzurg3MYLDcp8hdykLGItoOpDs2S6seFyZQWCDy/dVpBPtlAY0VfPagzQJREQtu+CiZWO+t4klfVbKioo0hfzCP0vQLF+cR/hXTXz2QbpJlaGhhe8ot81waKvbtI3MY52Mi8p9f6KMGyC7YgLD6Cll2lFCiL4WS69LoUt+ePZs+wnov/wX1UP5Mnf0mWuTJe7kmzW3nw+Gxx/1HlcamDdGk4DOWam0RcUcCPkt2uWa5QqffM6Ibg/uwmD/pmM3Rz+4oYL6pC+0uBzUTHAqZjyewGDypFLyY7VNNqszJzrjye7WeStTIOheswcSyWNK5LVY2bYWKv6Y106mx4iIl1I9XVifXv7Et/Dw0= sky@home"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCi98YRWL9clAOG7SWOcVy+7ZjyCYoSWsKVTcALQD8XoxuSEaxa1C2jaJEopz4NU5lc+soZ2nhnFefTTEgBjizW61+W14hr+ZhMkEP+qFK4SYyoStsGqQRBFNk6zVxO5egZ2k+Ir1g+Dg9sm9T6ijUTNNEv+AZtQ/l/z3UBH7ksRp4LzPbPTLOL7uprh4eGPNOwd0OD8cgAi49aCe7F9Nr3R+ocsyWnkZZ9B8IYszG6WH4HNOJDQFqUR+FxB+w6Hvv2F9cCvLOo/1+kgveEGSlbGZg5jlQgQeCmE8l6q/Bft+YwZVQENi7tsnPV+mC2nlAaHUd+JPPfJ+knpjxOlsD0EC5UQwSNx+0v/BKU2uMpkTiNXP9F/aZN92m20yZ/tsLsxc7kYTa+BL8emskPd1G4rLpMLd6me84nc9RR5C2yGJDMWP8A1FO+576dG3P4hvUQUR1vc+cCQiYTRR80V3H7JJWh61X+Ycct+ffzTBmOaF6gcsHvykXvk0OcKlEhYWQY9/djt8rJwvCx1LcHBnMQSBhAJmMMrQZ/saJmIvxN+dL0K3ig+yDsIcgifisx2UF1dX8EkIp/ZldiR2Ef+KMbxk6czb0okIVAaTBeCPhiRAMdVl9oJOyJo9fhYoWf0p0ygszPUTujkSvu+LIrr4DXq9/ssHAl667Mk+ElEVp4uQ== sky"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDvEwp2wJ9TwYn/daIbvaWQdZi+PMZ6fCOapew9cw6dOj5Cs6C5XcMakxgObH24eXf0VLXU+myi7ce1Y2Mc9TmRP20hVU8Z6TROK+QleJ+UvntW4EDjJfcnUj8MuY7iD3kPKcF4t9szW1oyAd6CSnzi14kTUAWPGXPNJTnNuxMgEbAcPm1/BzpWJIMDO316PZ3U+CqjgOXJyk3UVl4grxdivybJK54lQsDwWFkYmfPCB22Gb1UmMR3yOSFLVZMfDyXMnIlRNF8599S4Bm99ngvEp1xDJppz9L37e3UehMrawHlmGpBcjLbTi3OtwPJtpKYyx4PF4rNrg9fWFso85FdI+XA5k2B2N04ixrfQ3TP5A1HGDLLzYDvBsyuVo2pO9p5+uekG2SFT1bdqInUYqjbXm5Q10ufKWSYKJbreo9IjzC4mvpq8ouialgYftBt3PCXFlMMQdaLz64BpfKjjjbJelCbC7BNcbIWoRaobsXCZzQLuOIcjT0FQxXFlC348D90= mobile@Skys-iPad"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4Ondo0g2WWONyepyYMewovFugnbH/sXdygmetCKRThPeBsxjbbs6jLBienVagWgl2Dbv1QnA4c12hzW69hC6oiScfqYTVGUOuNC4LosG5eC7aNuecW5dJR+0DKtzmBtsGS4kFYRpoc5Wfr66a7aevMpJAiFSxl2BcyVqq4Nuv4FtM26IPI/KNJYko6OvRhNpsawNUBchVu0y3nnFlNfY3xnSIdXIeBOQ4WrXxA0KiBTmOIOqQr1rIrlgd8mHDwqmgKjE8D4jFeMmajemppvLrnjXkH2lwTtXlV3QENAxDVPOlgY+znFBoU7F+LJ5w53fXNY68lRP9A0dD09rN2Bc2u4K59NPScFixBhIokwcRyp5Sobm40TX/bahGsjPKVJ5JBUBYmNbJ1tScA4bMu7q1hjTDCEUm91kNqhcNHTMHSMSt0ko8Quojfg5gFY25qzJ2dQr8ddaMfT66ggPwtfBByJ6sFwDUr9Om98yRYLjxL7HWlGBSVRH5iMjDDKu5ldM= sky@MacBook-Air-de-Sky.local"
      ];
    };

    environment.etc.srb2 = {
      target = "srb2/.srb2/adedserv.cfg";
      text = cfg.config.clientConfig;
      mode = "0770";
      user = "srb2";
      group = "srb2";
    };

    systemd.services.srb2 = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        Requires = "network-online.target";
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/srb2 -dedicated -serverport ${
            toString cfg.port
          } -room 28 ${
            if length cfg.config.files > 0 then
              "-file ${toString cfg.config.files}"
            else
              ""
          }";
      };
      environment = { HOME = "/etc/srb2"; };
    };

    networking = {
      firewall = {
        allowedUDPPorts = [ cfg.port ];
        allowedTCPPorts = [ cfg.port ];
      };
    };
  };
}
