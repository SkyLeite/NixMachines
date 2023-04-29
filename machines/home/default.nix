# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, nixpkgs, modulesPath, monitors, ... }:

let
  usBr = pkgs.fetchFromGitHub {
    owner = "SkyLeite";
    repo = "us-br";
    rev = "e00b23128f668d621266904f7040998bab5c6168";
    sha256 = "1az5aqhm2hmsa2a43qr5k6djnc51sqr6zl2g21zf1kjv3n57nf2i";
  };

  microphone = {
    unit =
      "sys-devices-pci0000:00-0000:00:08.1-0000:0a:00.3-usb3-3\\x2d3-3\\x2d3:1.0-sound-card2-controlC2.device";
    id = "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-mono";
  };

  swayLauncher = pkgs.writeShellScript "swayLauncher" ''
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export QT_QPA_PLATFORM=wayland
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    exec ${pkgs.sway}/bin/sway $@
  '';

  steamLauncher = pkgs.writeShellScript "steamLauncher"
    "${pkgs.gamescope}/bin/gamescope -i -f -e -- ${pkgs.steam}/bin/steam -tenfoot -steamos -fulldesktopres";
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  imports = [ # Include the results of the hardware scan.
    (import ./hardware-configuration.nix {
      inherit modulesPath config lib pkgs;
    })
    # ./vfio.nix
    ../../modules/tailscale.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "home"; # Define your hostname.

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
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
  };

  fonts = {
    enableDefaultFonts = true;
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      noto-fonts-emoji
      dejavu_fonts
      inconsolata
      source-han-sans-japanese
      source-han-sans-korean
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese
      ubuntu_font_family
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = false;
    autorun = false;
    displayManager = {
      sddm.enable = false;
      gdm = {
        enable = false;
        wayland = true;
      };
      sessionCommands = ''
        ${pkgs.xorg.xmodmap}/bin/xmodmap ${usBr}/us-br
        autorandr -c
      '';
    };
    desktopManager = {
      xterm.enable = false;
      xfce = { enable = true; };
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
    windowManager.awesome = { enable = true; };
    videoDrivers = [ "amdgpu" ];
  };

  services.greetd = {
    enable = true;
    vt = 1;
    settings = {
      default_session = let
        swayGreetConfig = pkgs.writeText "greetd-sway-config" ''
          # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
          exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
          bindsym Mod4+shift+e exec swaynag \
            -t warning \
            -m 'What do you want to do?' \
            -b 'Poweroff' 'systemctl poweroff' \
            -b 'Reboot' 'systemctl reboot'
        '';
      in { command = "${swayLauncher} --config ${swayGreetConfig}"; };
    };
  };

  environment.etc."greetd/environments" = {
    enable = true;
    text = ''
      ${swayLauncher}
      ${steamLauncher}
    '';
  };

  services.tailscale.enable = true;
  services.tailscale-autoconnect = {
    enable = false;
    key = "";
  };

  services.persistent-evdev = {
    enable = true;
    devices = {
      persist-mouse0 =
        "usb-Logitech_G403_Prodigy_Gaming_Mouse_087838573135-event-mouse";
      persist-mouse1 =
        "usb-Logitech_G403_Prodigy_Gaming_Mouse_087838573135-if01-event-kbd";
      persist-mouse2 =
        "usb-Logitech_G403_Prodigy_Gaming_Mouse_087838573135-mouse";
      persist-keyboard0 =
        "usb-ZSA_Technology_Labs_Inc_ErgoDox_EZ_Glow-if01-event-mouse";
      persist-keyboard1 =
        "usb-ZSA_Technology_Labs_Inc_ErgoDox_EZ_Glow-event-if02";
      persist-keyboard2 =
        "usb-ZSA_Technology_Labs_Inc_ErgoDox_EZ_Glow-if02-event-kbd";
      persist-keyboard3 =
        "usb-ZSA_Technology_Labs_Inc_ErgoDox_EZ_Glow-event-kbd";
      persist-keyboard4 =
        "usb-ZSA_Technology_Labs_Inc_ErgoDox_EZ_Glow-if01-mouse";
    };
  };

  services.blueman.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "DP-1";
          max_fps = 60;
          exec_before = "disable_notifications.sh";
          exec_after = "enable_notifications.sh";
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };

    lxqt.enable = true;

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  services.flatpak.enable = true;

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
    jack.enable = true;
    wireplumber.enable = true;
  };

  programs.nm-applet.enable = true;
  programs.noisetorch.enable = true;
  programs.nix-ld.enable = true;
  programs.thunar = {
    enable = true;
    plugins = [ pkgs.xfce.thunar-archive-plugin ];
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
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

  users = {
    groups = {
      music = {
        name = "music";
        gid = 101;
      };
    };

    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      sky = {
        isNormalUser = true;
        createHome = true;
        description = "Sky Leite";
        extraGroups = [
          "cdrom"
          "music"
          "wheel"
          "docker"
          "libvirtd"
          "kvm"
          "input"
          "adbusers"
          "audio"
          "networkmanager"
        ];
        group = "users";
        home = "/home/sky";
        hashedPassword =
          "$6$BxcfpoGqb.I$msdWrRc75bsmegjGBvrC.qRS1Hw5KR0OjseqTZnxoN.U7W52srD5WWT0w4Z5QhFjZaq7/gzQXQ1YUfSlvcE13.";
        uid = 1234;
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          # ipad
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCi98YRWL9clAOG7SWOcVy+7ZjyCYoSWsKVTcALQD8XoxuSEaxa1C2jaJEopz4NU5lc+soZ2nhnFefTTEgBjizW61+W14hr+ZhMkEP+qFK4SYyoStsGqQRBFNk6zVxO5egZ2k+Ir1g+Dg9sm9T6ijUTNNEv+AZtQ/l/z3UBH7ksRp4LzPbPTLOL7uprh4eGPNOwd0OD8cgAi49aCe7F9Nr3R+ocsyWnkZZ9B8IYszG6WH4HNOJDQFqUR+FxB+w6Hvv2F9cCvLOo/1+kgveEGSlbGZg5jlQgQeCmE8l6q/Bft+YwZVQENi7tsnPV+mC2nlAaHUd+JPPfJ+knpjxOlsD0EC5UQwSNx+0v/BKU2uMpkTiNXP9F/aZN92m20yZ/tsLsxc7kYTa+BL8emskPd1G4rLpMLd6me84nc9RR5C2yGJDMWP8A1FO+576dG3P4hvUQUR1vc+cCQiYTRR80V3H7JJWh61X+Ycct+ffzTBmOaF6gcsHvykXvk0OcKlEhYWQY9/djt8rJwvCx1LcHBnMQSBhAJmMMrQZ/saJmIvxN+dL0K3ig+yDsIcgifisx2UF1dX8EkIp/ZldiR2Ef+KMbxk6czb0okIVAaTBeCPhiRAMdVl9oJOyJo9fhYoWf0p0ygszPUTujkSvu+LIrr4DXq9/ssHAl667Mk+ElEVp4uQ== sky"

          # miles
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFIbNWbPJ5TExvDqs9g0cMsvOOwsfY4PV2p4pIXyQn0x6E11ly2HbKfVFhA2sUhS95qIN/ZJmYe0M0YHP003NKe2cRopcnn0wzvHkti9aF+4bh05c7CLf9mc7ajEzbNQ1p7urmLNibWh/XXP+D3k/pnX9W2TzKAmT+fVmKOFIpg0Cja2i6aRpflwD3Yj+xAsTDLkf4MA/He4M+MFpDnKNqWUUQyY/w1wUNroFZe4lBL/CWLEfHYgfqLXnGFFHoQ9fkgU+W8T6GYoF4aaRrI18QQBxdXLrpyMWWg6zvMiJM78CIZfVKC7CwOgFjbvcpIcbbGRzu7f5MMhtXOlKeeuv75oSISltiVIfKDDPZbvtw6t+XVxCrwFLoeIyHrd4JNv82/lEejDq76j9gvuBCypZCGzuGrCNa0Y5l1zVfnrtFaiKtFmFeTA4nlFLEUvyRnB70kXdTyKI9qhCn+nyhBDt26RTOPSLwJpHvPRQTRA4Vem0Ibfzg0RERgfWBNeFRrOM= sky@miles"
        ];
      };

      musicdownloader = {
        isSystemUser = true;
        createHome = false;
        description = "Music Downloader";
        group = "music";
        extraGroups = [ "deluge" ];
      };

      deluge = {
        isSystemUser = true;
        extraGroups = [ "music" ];
      };
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      services = {
        swaylock = {
          text = ''
            auth include login
          '';
        };
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bitwarden
    discord
    docker
    docker-compose
    editorconfig-core-c
    fd
    git
    gparted
    neovim
    nixfmt
    pciutils
    python3
    ripgrep
    wget
    xclip
    xorg.xkbcomp
    pavucontrol
    ncpamixer
    pinentry-curses
    pass
    unzip
    openssl
    ffmpeg
    slack
    nix-index
    tailscale
    bitwarden-cli
    monitors.outputProfileScript
  ];

  programs.zsh.enable = true;
  services.avahi.enable = true;
  services.pcscd.enable = true;
  programs.mosh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.adb.enable = true;

  # List services that you want to enable:
  services.lorri.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = { X11Forwarding = true; };
  };
  virtualisation.docker.enable = true;

  services.deluge = {
    enable = true;
    web = {
      enable = true;
      port = 8112;
    };
  };

  nix = {
    settings = {
      trusted-substituters =
        [ "https://cache.nixos.org" "https://cache.iog.io" ];
      trusted-public-keys =
        [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
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
  networking.networkmanager = { enable = true; };
  # networking.firewall.allowedTCPPorts = [ 22 80 8080 8000 11470 ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
