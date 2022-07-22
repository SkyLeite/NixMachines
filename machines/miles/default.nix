{ config, pkgs, attrs, ... }:

let build-machine = (pkgs.callPackage ../common/build-machine.nix { });
in {
  imports = [
    ./hardware-configuration.nix
    ../../services/webhook.nix
    ../../services/dashy.nix
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
    firewall = { enable = true; };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    hostName = "miles";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = { defaultLocale = "en_US.UTF-8"; };

  chaos = {
    enable = true;
    baseUrl = "localhost";
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = true;
    };

    sshd.enable = true;

    logind.lidSwitch = "ignore";
    logind.lidSwitchDocked = "ignore";

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

    dashy = {
      enable = true;
      config = {
        pageInfo = { title = "Miles"; };

        sections = [{
          name = "Information";
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
  };

  nixpkgs.system = "x86_64-linux";
  nixpkgs.config = { allowUnfree = true; };

  environment.systemPackages = with pkgs; [
    cloc
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
    p7zip
    pavucontrol
    sxiv
    unzip
    wget
    xsel
    zip
    python38
    hello
    build-machine
    pass
    pinentry-curses
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
