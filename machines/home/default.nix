# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  usBr = pkgs.fetchFromGitHub {
    owner = "SkyLeite";
    repo = "us-br";
    rev = "e00b23128f668d621266904f7040998bab5c6168";
    sha256 = "1az5aqhm2hmsa2a43qr5k6djnc51sqr6zl2g21zf1kjv3n57nf2i";
  };

  microphone = {
    unit =
      "sys-devices-pci0000:00-0000:00:08.1-0000:0a:00.4-sound-card1-controlC1.device";
    id = "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-mono";
  };
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [ pango libthai harfbuzz ];
    };
  };

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./vfio.nix
    ../../services/noisetorch.nix
  ];

  services.noisetorch = {
    enable = true;
    unit = microphone.unit;
    id = microphone.id;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "home"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  networking = {
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    hosts = { };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    displayManager = {
      sddm.enable = true;
      sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${usBr}/us-br";
    };
    desktopManager = {
      xterm.enable = false;
      xfce = { enable = true; };
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
    videoDrivers = [ "amdgpu" ];
  };

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      [global]

      max protocol = NT1
      min protocol = CORE
      ntlm auth = yes
      keepalive = 0
      smb ports = 445
    '';
    shares = {
      public = {
        path = "/mnt/hdd/Console Games";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };

      PS2SMB = {
        comment = "PS2 SMB";
        path = "/mnt/hdd/Console Games/PS2";
        browseable = "yes";
        "public" = "yes";
        "available" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  services.blueman.enable = true;
  services.k3s.enable = false;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          {
            "node.name" = "~bluez_input.*";
          }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = { "node.pause-on-idle" = false; };
      }
    ];
  };
  programs.noisetorch.enable = true;
  programs.nix-ld.enable = true;
  programs.thunar = {
    enable = true;
    plugins = [ pkgs.xfce.thunar-archive-plugin ];
  };

  hardware.bluetooth.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3006", TAG+="uaccess"
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    createHome = true;
    description = "Sky Leite";
    extraGroups =
      [ "wheel" "docker" "libvirtd" "kvm" "input" "adbusers" "audio" ];
    group = "users";
    home = "/home/sky";
    hashedPassword =
      "$6$BxcfpoGqb.I$msdWrRc75bsmegjGBvrC.qRS1Hw5KR0OjseqTZnxoN.U7W52srD5WWT0w4Z5QhFjZaq7/gzQXQ1YUfSlvcE13.";
    uid = 1234;
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bitwarden
    discord
    docker
    docker-compose
    editorconfig-core-c
    emacs
    fd
    firefox
    flameshot
    git
    gparted
    neovim
    nixfmt
    pciutils
    peek
    plasma-desktop
    python3
    ripgrep
    teams
    wget
    xclip
    virtualbox
    xorg.xkbcomp
    pavucontrol
    ncpamixer
    pinentry-curses
    pass
    unzip
    openssl
    ffmpeg
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.steam.enable = true;
  programs.adb.enable = true;

  # List services that you want to enable:
  services.lorri.enable = false;

  # Enable the OpenSSH daemon.
  services.sshd.enable = true;
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  users.extraGroups.vboxusers.members = [ "sky" ];

  # services.xserver.config = lib.mkAfter ''
  # Section "Extensions"
  #   Option "MIT-SHM" "Disable"
  # EndSection
  # '';

  services.mopidy = {
    enable = true;
    extensionPackages = [
      pkgs.mopidy-mpd
      pkgs.mopidy-scrobbler
      pkgs.mopidy-mpris
      pkgs.mopidy-local
      pkgs.mopidy-youtube
    ];
    configuration = ''
      [mpd]
      enabled = true

      [youtube]
      enabled = true
    '';
    extraConfigFiles = [ "/etc/nixos/mopidy/mopidy.conf" ];
  };

  nix = {
    settings = {
      substituters = [ ];
      trusted-public-keys = [ ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
    '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ 22 80 8080 8000 11470 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
