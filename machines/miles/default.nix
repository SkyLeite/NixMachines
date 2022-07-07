{ config, pkgs, attrs, ... }:

let build-machine = (pkgs.callPackage ../common/build-machine.nix { });
in {
  imports = [ ./hardware-configuration.nix ../../services/webhook.nix ];

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
      allowedTCPPorts = [ 5000 ];
      allowedUDPPorts = [ 5000 ];
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    hostName = "miles";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = { defaultLocale = "en_US.UTF-8"; };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = true;
    };

    sshd.enable = true;

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
          match = {
            type = "value";
            value = "refs/heads/main";
            parameter = {
              source = "payload";
              name = "ref";
            };
          };
        };
      }];
    };
  };

  programs.ssh.startAgent = true;
  programs.bash.enableCompletion = true;

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
    gnupg
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
  };

  system.stateVersion = "22.11";
}
