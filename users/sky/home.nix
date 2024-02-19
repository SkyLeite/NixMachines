{ config, pkgs, lib, nix-colors, gbar, ... }:

let
  mod = "Mod4";
  dbus-tabs = pkgs.callPackage ./packages/dbus-tabs.nix pkgs;

  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };

  rofi-libvirt = import ./scripts/rofi-libvirt.nix pkgs;
  rofi-firefox = pkgs.callPackage ./scripts/rofi-firefox.nix pkgs;
  bitwarden = import ../../util/bitwarden.nix;

  gamescopeSteam = pkgs.makeDesktopItem {
    name = "Steam (Gamescope)";
    exec =
      "${pkgs.gamescope}/bin/gamescope -W 5120 -H 1440 -w 5120 -h 1440 -U -i -f -e -- ${pkgs.steam}/bin/steam -tenfoot -steamos -fulldesktopres";
    comment = "Steam big picture running in gamescope";
    desktopName = "Steam (Gamescope)";
    categories = [ "Game" ];
  };

  gamescopeSteam4k = pkgs.makeDesktopItem {
    name = "Steam (Gamescope 4k)";
    exec =
      "${pkgs.gamescope}/bin/gamescope -W 3840 -H 2160 -w 3840 -h 2160 -U -i -f -e -- ${pkgs.steam}/bin/steam -tenfoot -steamos -fulldesktopres";
    comment = "Steam big picture running in gamescope 4k";
    desktopName = "Steam (Gamescope 4k)";
    categories = [ "Game" ];
  };

  customXivLauncher = pkgs.xivlauncher.overrideAttrs (base: {
    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "xivlauncher";
        exec = "XIVLauncher.Core";
        icon = "xivlauncher";
        desktopName = "XIVLauncher (Native)";
        comment = base.meta.description;
        categories = [ "Game" ];
        startupWMClass = "XIVLauncher.Core";
      })
    ];
  });
in {
  imports = [
    nix-colors.homeManagerModule
    gbar.homeManagerModules.x86_64-linux.default
    #./polybar
    ./variables.nix
    ./i3.nix
    ./sway.nix
    ./awesomewm.nix
    ./tmux.nix
    ./neovim.nix
    ./scripts/gui.nix
    ./emacs/default.nix
    ./gbar/default.nix
    ./eww/default.nix
    ./packages/noisetorch.nix
  ];

  variables = {
    wallpaper = ./wallpapers/djdK2IJ.png;
    colorScheme = nix-colors-lib.colorSchemeFromPicture {
      path = ./wallpapers/ffmobile.jpg;
      kind = "light";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.keyboard = false;
  home.packages = [
    pkgs.playerctl
    pkgs.gimp
    pkgs.virt-manager
    pkgs.xorg.xmodmap
    pkgs.libnotify
    pkgs.libreoffice
    pkgs.inotify-tools

    pkgs.htop
    pkgs.tty-clock

    pkgs.jre8
    pkgs.jdk8
    pkgs.mpv
    pkgs.deluge
    pkgs.sqls
    pkgs.gnome.zenity
    pkgs.remmina
    pkgs.pamixer
    pkgs.barrier
    # my-nur.ncpamixer-git
    pkgs.dbeaver
    pkgs.strawberry
    pkgs.vscode.fhs
    pkgs.gnumake
    pkgs.source-code-pro
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.font-awesome
    pkgs.font-awesome_5
    pkgs.pulsemixer
    pkgs.dfeet
    pkgs.comma
    pkgs.hexchat
    pkgs.wineWowPackages.unstableFull
    pkgs.winetricks
    pkgs.chromium
    pkgs.lutris
    pkgs.mpc_cli
    pkgs.gh
    pkgs.libunwind
    pkgs.ripgrep
    pkgs.sqlite
    pkgs.wordnet
    pkgs.prismlauncher
    pkgs.protontricks
    pkgs.proton-caller
    pkgs.spotify
    pkgs.gamescope
    pkgs.mangohud
    pkgs.rpcs3
    pkgs.jq
    pkgs.steamtinkerlaunch
    pkgs.xdotool
    pkgs.xorg.xprop
    pkgs.unixtools.xxd
    pkgs.xorg.xwininfo
    pkgs.yad
    pkgs.yuzu-mainline
    pkgs.prusa-slicer
    # pkgs.obsidian
    pkgs.unar
    pkgs.p7zip
    pkgs.srb2kart
    pkgs.cachix

    # customXivLauncher
    gamescopeSteam
    gamescopeSteam4k
  ];

  home = {
    sessionPath = [
      "$HOME/.local/ActiveState/StateTool/beta/bin"
      # "/mnt/hdd/projects/TheHomeRepot/third_party/bin"
    ];
    sessionVariables = {
      DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
      EDITOR = "emacs";
    };
  };

  programs.git = {
    enable = true;
    userName = "Sky";
    userEmail = "sky@leite.dev";
    extraConfig = {
      init = { defaultBranch = "main"; };
      github.user = "SkyLeite";
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles.sky = {
      settings = {
        "browser.search.isUS" = false;
        "browser.bookmarks.showMobileBookmarks" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        /* Hide tab bar in FF Quantum */
        @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

          #titlebar {
            visibility: collapse !important;
            margin-bottom: 21px !important;
          }

          #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
            visibility: collapse !important;
          }
      '';
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Source Code Pro";
          style = "Regular";
        };
        bold = {
          family = "Source Code Pro";
          style = "Bold";
        };
        italic = {
          family = "Source Code Pro";
          style = "Italic";
        };
        bold_italic = {
          family = "Source Code Pro";
          style = "Bold Italic";
        };
      };
      window = {
        dynamic_padding = true;
        opacity = 0.95;
        padding = {
          x = 15;
          y = 10;
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    plugins = [ ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "alanpeabody";
    };
    initExtra = ''
      export PATH
      eval "$(direnv hook zsh)"

      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false

      # set descriptions format to enable group support
      zstyle ':completion:*:descriptions' format '[%d]'

      # preview directory's content with exa when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

      # switch group using `,` and `.`
      zstyle ':fzf-tab:*' switch-group ',' '.'

      # complete makefile
      zstyle ':completion:*:*:make:*' tag-order 'targets'
    '';
    shellAliases = { sysyadm = "sudo yadm -Y /etc/yadm"; };
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
    theme = "Arc-Dark";
    extraConfig = {
      modi = "emoji,drun,ssh,firefox:${rofi-firefox}/bin/rofi-firefox.sh";
      kb-primary-paste = "Control+V,Shift+Insert";
      kb-secondary-paste = "Control+v,Insert";
      padding = 18;
      width = 60;
      font = "Noto Sans 12";

      kb-mode-next = "Tab";
      kb-mode-previous = "ISO_Left_Tab";
      kb-element-prev = "";
      kb-element-next = "";
    };
  };

  programs.ncmpcpp = {
    enable = true;
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = [ "select_item" "scroll_down" ];
      }
      {
        key = "K";
        command = [ "select_item" "scroll_up" ];
      }
    ];
  };

  services.noisetorch.enable = true;

  services.syncthing = {
    enable = true;
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      work = {
        hostname = "192.168.122.21";
        user = "sky";
        identityFile = "/home/sky/.ssh/id_rsa";
        forwardX11 = true;
        forwardX11Trusted = true;
        compression = true;
        localForwards = map (port: {
          bind.port = port;
          host.address = "127.0.0.1";
          host.port = port;
        }) [ 1313 3000 ];
        extraOptions = { };
      };
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };

    configFile."mimeapps.list".force = true;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "text/plain" = "emacs.desktop";
        "image/png" = "org.xfce.ristretto.desktop";
        "image/jpeg" = "org.xfce.ristretto.desktop";
        "image/gif" = "org.xfce.ristretto.desktop";
        "image/webp" = "firefox.desktop";
        "application/zip" = "xarchiver.desktop";
        "application/x-7z-compressed" = "xarchiver.desktop";
        "application/vnd.rar" = "xarchiver.desktop";
      };
    };
  };

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    Unit = {
      Description = "polkit-kde-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = {
      Type = "simple";
      ExecStart =
        "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sky";
  home.homeDirectory = "/home/sky";
  home.file = {
    "test.sh" = { text = builtins.exec [ "bash" "-c" ''echo \"hi\"'' ]; };
    #"test2.sh" = { text = bitwarden.get "password" "Github"; };

    ".mozilla/native-messaging-hosts/dbus_tabs.json" = {
      text = ''
        {
            "name": "dbus_tabs",
            "description": "Host for native messaging",
            "path": "${dbus-tabs}/dbus_tabs_native_service.py",
            "type": "stdio",
            "allowed_extensions": ["dbus_tabs@cubimon.org"]
        }
      '';
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
