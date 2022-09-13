{ config, pkgs, attrs, ... }:

let build-machine = (pkgs.callPackage ../common/build-machine.nix { });
in {
  imports = [
    ./hardware-configuration.nix
    ../../services/webhook.nix
    ../../services/dashy.nix
    ../../services/n8n.nix
    ../../services/papermc.nix
    ../../services/funkwhale/default.nix
    ../../modules/chaos-service.nix
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
    firewall = {
      enable = true;
      allowedUDPPorts = [ 34197 ];
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    hostName = "miles";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = { defaultLocale = "en_US.UTF-8"; };

  chaos = {
    enable = true;
    baseUrl = "zerolab.app";
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    sshd.enable = true;

    logind.lidSwitch = "ignore";
    logind.lidSwitchDocked = "ignore";

    papermc.enable = false;

    funkwhale.enable = true;

    webhook = {
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
      enable = true;
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
  };

  virtualisation.docker.enable = true;
  programs.ssh.startAgent = true;
  programs.bash.enableCompletion = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  time.timeZone = "Americas/Sao_Paulo";

  # Users
  users.extraUsers.sky = {
    isNormalUser = true;
    createHome = true;
    home = "/home/sky";
    description = "Sky Leite";
    group = "sky";
    extraGroups = [ "wheel" "audio" "video" "networkmanager" "docker" ];
    useDefaultShell = true;
    initialPassword = "1234";

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3ykdS45NmqGsuAjBJuUaMJx/QjA8Xzb4Gh41XNdsRcy2I9YM5p+FU6FoCDLyPYRgI+tSVS3UzkKwvMLwxgruRxEyjHBLbch+9U9e9PrRfSZjYLnkyHVZIujDiwYFcPBPiw8Bp87/dWxe+/b3YWoPgMTcT1FkEHfESi1uwZKq1I84pXCY43pBIwjcKXn9uhgSZpKA7SaW+TyWKI+jrYU7UpTEJsq6fDiE02Xibx2GtflPo1Y217pNjyq40uCBXooiqzKAKWPc7re1NlXz234tVjE4iRwxvAjSddbPzlHeW+3I+/To/VMQ+lqNQOIQRhoPiq12WYTGA9hHU2tn4st/JjdMPRsGQpH6PkJj0ikvpDCiPRF82uhRsy27I2REqaMvAzqr7REgm8vrW6eWXBNr/wowchjVhDcoSHe8DYtQSWad+eKN7+dNi/c4if5iwwdmHx7vEpIHWsmit6U/mx1cu+vM8G5+VPVMx4vUcOM66Mqusm3MzrUb/+SUsrBxjWnU= sky@home"
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
    networkmanager
    nmap
    openssl
    pavucontrol
    wget
    xsel
    python38
    build-machine
    pass
    pinentry-curses
    vim
    emacs
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

    extraOptions = ''
      plugin-files = ${
        pkgs.nix-plugins.override { nix = config.nix.package; }
      }/lib/nix/plugins
    '';
  };

  system.stateVersion = "22.11";
}
