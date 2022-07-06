{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

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
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    hostName = "aya";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = { defaultLocale = "en_US.UTF-8"; };

  # nVidia driver
  hardware.opengl.driSupport32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = true;
    };

    sshd.enable = true;
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
  nixpkgs.config = {
    virtualbox.enableExtensionPack = true;
    pulseaudio = true;
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    cacert
    cloc
    elfutils
    emacs
    file
    firefox-devedition-bin
    git
    glib
    glxinfo
    gnupg
    gnutls
    htop
    jq
    mpv
    mupdf
    networkmanager
    nitrogen
    nmap
    openssl
    p7zip
    pavucontrol
    rxvt_unicode
    scrot
    sxiv
    unzip
    wget
    xscreensaver
    xsel
    zip
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
      substituters = [ "http://cache.nixos.org" ];
      trusted-substituters = [ "http://cache.nixos.org" ];
    };

    gc.automatic = false;
  };

  system.stateVersion = "22.11";
}
