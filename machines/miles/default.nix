{ config, pkgs, attrs, ... }:

let build-machine = (pkgs.callPackage ../common/build-machine.nix { });
in {
  imports = [
    ./hardware-configuration.nix
    ../../services/webhook.nix
    ../../services/dashy.nix
    ../../services/n8n.nix
    ../../services/papermc/default.nix
    ../../services/home-assistant.nix
    ../../services/nocodb.nix
    ../../modules/chaos-service.nix
    ./srb2kart/default.nix
    ./kartwiki/default.nix
    ./srb2infinity/default.nix
  ];

  boot = {
    blacklistedKernelModules = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "exfat" ];
  };

  networking = {
    hostName = "miles";
    domain = "home";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ 34197 ];
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  # Select internationalisation properties.
  i18n = { defaultLocale = "en_US.UTF-8"; };

  chaos = {
    enable = true;
    baseUrl = "zerolab.app";

    services.octoprint = {
      enable = true;
      port = config.services.octoprint.port;
    };

    services.syncthing = {
      enable = true;
      port = 8384;
    };

    services.cockpit = {
      enable = true;
      port = config.services.cockpit.port;
    };

    services.cloud = {
      enable = true;
      port = 6528;
    };
  };

  services = {
    avahi.enable = true;

    postgresql = {
      enable = true;
      port = 5432;
      ensureUsers = [
        {
          name = "nocodb";
          ensurePermissions = {
            "DATABASE \"db\"" = "ALL PRIVILEGES";
            "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
          };
          ensureClauses.login = true;
        }
        {
          name = "n8n";
          ensurePermissions = {
            "DATABASE \"db\"" = "ALL PRIVILEGES";
            "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
          };
          ensureClauses.login = true;
        }
        {
          name = "nextcloud";
          ensurePermissions = {
            "DATABASE \"db\"" = "ALL PRIVILEGES";
            "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
          };
          ensureClauses.login = true;
        }
      ];
      ensureDatabases = [ "db" ];
      enableTCPIP = false;
      authentication = ''
        local db nocodb trust
        host  db nocodb localhost trust

        local db n8n    trust
        host  db n8n    localhost trust

        local mediawiki mediawiki    trust
        host  mediawiki mediawiki    localhost trust
      '';
    };

    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    nocodb.enable = true;

    cockpit = {
      enable = true;
      openFirewall = false;
      port = 8104;
      settings = {
        WebService = { Origins = "https://cockpit.${config.chaos.baseUrl}"; };
      };
    };

    udisks2 = {
      enable = true;
      mountOnMedia = false;
    };

    home-assistant-oci.enable = true;

    sshd.enable = true;

    logind.lidSwitch = "ignore";
    logind.lidSwitchDocked = "ignore";

    papermc.enable = true;

    webhookCustom = {
      enable = true;
      port = 5000;
      verbose = true;

      webhooks = [{
        id = "github-rebuild";
        execute-command = "${build-machine}/bin/build-machine";
        pass-arguments-to-command = [{
          source = "payload";
          name = "after";
        }];
        trigger-rule = {
          and = [
            {
              or = map (x: {
                match = {
                  type = "ip-whitelist";
                  ip-range = x;
                };
              }) [
                "192.30.252.0/22"
                "185.199.108.0/22"
                "140.82.112.0/20"
                "143.55.64.0/20"
                "2a0a:a440::/29"
                "2606:50c0::/32"
              ];
            }
            {
              match = {
                type = "value";
                value = "refs/heads/main";
                parameter = {
                  source = "payload";
                  name = "ref";
                };
              };
            }
            {
              match = {
                type = "value";
                value = "511297545";
                parameter = {
                  source = "payload";
                  name = "repository.id";
                };
              };
            }
          ];
        };
      }];
    };

    wrappedN8n.enable = true;

    dashy = {
      enable = true;
      config = {
        pageInfo = { title = "Miles"; };

        sections = [{
          name = "Meta";
          icon = "far fa-rocket";
          items = [
            {
              title = "My configuration <3";
              description = "The nix definition for this machine";
              icon = "fab fa-github";
              url =
                "https://github.com/SkyLeite/NixMachines/blob/main/machines/miles/default.nix";
            }
            {
              title = "Sky's blog";
              description = "The architect's findings";
              icon = "fas fa-book";
              url = "https://leite.dev";
              target = "newtab";
              tags = [ "blog" ];
              provider = "Netlify";
            }
          ];
        }];
      };
    };

    factorio = {
      enable = false;
      admins = [ "Sky" ];
      openFirewall = true;
      game-name = "Dr. Zap";
      game-password = "drzap";
      loadLatestSave = true;
      description = "*emoji apontando o dedo*";
      public = true;
      username = "Kaze404";
      token = "07ffc97315dd787e2b6cde6810a9e5";
    };

    octoprint = {
      enable = true;
      port = 1414;
    };

    # Nextcloud port
    nginx.virtualHosts."localhost".listen = [ { addr = "127.0.0.1"; port = 6528; } ];
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      hostName = "cloud.leite.dev";
      database.createLocally = true;
      configureRedis = true;
      https = true;
      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbname = "nextcloud";
        adminpassFile = "/etc/nextcloud-admin-pass";
        defaultPhoneRegion = "br";
        overwriteProtocol = "https";
        trustedProxies = [
          "127.0.0.1"
          "localhost"
        ];
      };
      notify_push.enable = true;
      caching.redis = true;
    };
  };

  environment.etc."nextcloud-admin-pass".text = "test123";

  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "podman";
  programs.ssh.startAgent = true;
  programs.mosh.enable = true;
  programs.bash.enableCompletion = true;

  services.pcscd.enable = true;

  services.syncthing = {
    enable = true;
    configDir = "/srv/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
    devices = {
      "sky-ipad" = {
        id = "PAYYTNA-6PU2FTP-VY7ATRQ-GAX4AIW-5KD2IAQ-VDCBLNJ-VGJPTSE-OGFKOQ2";
      };
    };
    folders = {
      # Obsidian notes
      "gyakq-yzxwg" = {
        path = "/var/lib/syncthing/Obsidian";
        devices = [ "sky-ipad" ];
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  time.timeZone = "Americas/Sao_Paulo";

  # Users
  users.groups.sky = {};
  users.extraUsers.sky = {
    isNormalUser = true;
    createHome = true;
    home = "/home/sky";
    description = "Sky Leite";
    group = "sky";
    extraGroups = [ "wheel" "audio" "video" "docker" "networkmanager" ];
    useDefaultShell = true;
    initialPassword = "1234";

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwRAmo21nhKK0vtVUb9qycqlbIjeR9UF0Y04D0c6hjXR8Vp2f5jq+fQZERsowV/c6RsOA25JS/wHLMB3QsSJeZzxYfpKsflbTe5zx1V1phOAfBCxQgDd3jZ5yyWqfP9VnyFqrY6g1pD7BhbgDTCNZirzKHv6FSnzurg3MYLDcp8hdykLGItoOpDs2S6seFyZQWCDy/dVpBPtlAY0VfPagzQJREQtu+CiZWO+t4klfVbKioo0hfzCP0vQLF+cR/hXTXz2QbpJlaGhhe8ot81waKvbtI3MY52Mi8p9f6KMGyC7YgLD6Cll2lFCiL4WS69LoUt+ePZs+wnov/wX1UP5Mnf0mWuTJe7kmzW3nw+Gxx/1HlcamDdGk4DOWam0RcUcCPkt2uWa5QqffM6Ibg/uwmD/pmM3Rz+4oYL6pC+0uBzUTHAqZjyewGDypFLyY7VNNqszJzrjye7WeStTIOheswcSyWNK5LVY2bYWKv6Y106mx4iIl1I9XVifXv7Et/Dw0= sky@home"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCi98YRWL9clAOG7SWOcVy+7ZjyCYoSWsKVTcALQD8XoxuSEaxa1C2jaJEopz4NU5lc+soZ2nhnFefTTEgBjizW61+W14hr+ZhMkEP+qFK4SYyoStsGqQRBFNk6zVxO5egZ2k+Ir1g+Dg9sm9T6ijUTNNEv+AZtQ/l/z3UBH7ksRp4LzPbPTLOL7uprh4eGPNOwd0OD8cgAi49aCe7F9Nr3R+ocsyWnkZZ9B8IYszG6WH4HNOJDQFqUR+FxB+w6Hvv2F9cCvLOo/1+kgveEGSlbGZg5jlQgQeCmE8l6q/Bft+YwZVQENi7tsnPV+mC2nlAaHUd+JPPfJ+knpjxOlsD0EC5UQwSNx+0v/BKU2uMpkTiNXP9F/aZN92m20yZ/tsLsxc7kYTa+BL8emskPd1G4rLpMLd6me84nc9RR5C2yGJDMWP8A1FO+576dG3P4hvUQUR1vc+cCQiYTRR80V3H7JJWh61X+Ycct+ffzTBmOaF6gcsHvykXvk0OcKlEhYWQY9/djt8rJwvCx1LcHBnMQSBhAJmMMrQZ/saJmIvxN+dL0K3ig+yDsIcgifisx2UF1dX8EkIp/ZldiR2Ef+KMbxk6czb0okIVAaTBeCPhiRAMdVl9oJOyJo9fhYoWf0p0ygszPUTujkSvu+LIrr4DXq9/ssHAl667Mk+ElEVp4uQ== sky"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDvEwp2wJ9TwYn/daIbvaWQdZi+PMZ6fCOapew9cw6dOj5Cs6C5XcMakxgObH24eXf0VLXU+myi7ce1Y2Mc9TmRP20hVU8Z6TROK+QleJ+UvntW4EDjJfcnUj8MuY7iD3kPKcF4t9szW1oyAd6CSnzi14kTUAWPGXPNJTnNuxMgEbAcPm1/BzpWJIMDO316PZ3U+CqjgOXJyk3UVl4grxdivybJK54lQsDwWFkYmfPCB22Gb1UmMR3yOSFLVZMfDyXMnIlRNF8599S4Bm99ngvEp1xDJppz9L37e3UehMrawHlmGpBcjLbTi3OtwPJtpKYyx4PF4rNrg9fWFso85FdI+XA5k2B2N04ixrfQ3TP5A1HGDLLzYDvBsyuVo2pO9p5+uekG2SFT1bdqInUYqjbXm5Q10ufKWSYKJbreo9IjzC4mvpq8ouialgYftBt3PCXFlMMQdaLz64BpfKjjjbJelCbC7BNcbIWoRaobsXCZzQLuOIcjT0FQxXFlC348D90= mobile@Skys-iPad"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+XuAGZCePLDBqbDTbbNdkROmjghb6oECPwElYATm+y7aLYtdCpUqPyp5bcfFsvIkt5nvO0ZpXguVyuXEjDDmxyYrCStgc2S2f0syIPLVmiBYvHb3kOF9jA8PyQmA3nXWq83AU+inj1AK9xcQ6ujMjPKM8ZnpVdtM0uOTYWS9+o8nBv7xQwFyn0+rv2wQBk1rULtgCIk1qbGrj1NmuH0nvE85l09jmVi4Etocidrrb0Ur2zmZpreN3JFhRnQPgeP+svCnOb33GiiUphrRGHS5ajty5KbheuI/QaRZe3dK8vXgLfDYL8vJzx8MhnjBZrPHs55JlUzcVx3wcRM2p8XTE7ZKcvar0mwpaJUpdWj0pCFjGI08MbWDz1GBiHKs4X2xxLContZ6T5T3IyrGiXKD0FzSE3PJTJUfqUTXgl6wu3WRvKP6GpgQ7rszSfIANakehNM2WalL+Pog3p9cL/6zRIyksaRDDrOrKyPP2B55dT7zXYeorJcsAXMBxiAIfbUc= sky@ange"
    ];
  };

  nixpkgs.system = "x86_64-linux";
  nixpkgs.config = { allowUnfree = true; };

  environment.systemPackages = with pkgs; [
    elfutils
    file
    git
    glib
    gnutls
    htop
    jq
    nmap
    openssl
    pavucontrol
    wget
    xsel
    build-machine
    pass
    pinentry-curses
    vim
    hello
    curl
  ];

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      inconsolata
      source-han-sans-japanese
      source-han-sans-korean
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese
      ubuntu_font_family
    ];
  };

  security.sudo.enable = true;
  security.polkit.enable = true;

  nix = {
    package = pkgs.nixUnstable;

    settings = {
      substituters = [
        "https://aseipp-nix-cache.global.ssl.fastly.net"
        "https://nix-community.cachix.org"
        "http://cache.nixos.org"
      ];

      trusted-substituters = [ "http://cache.nixos.org" ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc.automatic = false;
  };

  system.stateVersion = "22.11";
}
