{ config, pkgs, lib, ... }:

let
  mod = "Mod4";
  my-nur = import /mnt/hdd/projects/nix-repository { };
  dbus-tabs = pkgs.callPackage ./packages/dbus-tabs.nix pkgs;

  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };

  lol-launchhelper = my-nur.lol-launchhelper;
  rofi-libvirt = import ./scripts/rofi-libvirt.nix pkgs;
  rofi-firefox = pkgs.callPackage ./scripts/rofi-firefox.nix pkgs;
  etterna = pkgs.callPackage ../../packages/etterna/default.nix pkgs;
  bitwarden = import ../../util/bitwarden.nix;
in {
  imports = [
    ./polybar
    ./i3.nix
    ./awesomewm.nix
    ./tmux.nix
    ./neovim.nix
    ./scripts/gui.nix
    ./emacs/default.nix
    ./packages/deadd.nix
    #./packages/xborder.nix
    ./packages/noisetorch.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.keyboard = false;
  home.packages = [
    pkgs.nodejs
    pkgs.elixir
    pkgs.elixir_ls
    pkgs.yarn
    pkgs.playerctl
    pkgs.simplescreenrecorder
    pkgs.arandr
    pkgs.gimp
    pkgs.virt-manager
    pkgs.xorg.xmodmap
    pkgs.libnotify
    pkgs.yadm
    pkgs.clojure
    pkgs.clojure-lsp
    pkgs.clj-kondo
    pkgs.leiningen
    pkgs.boot
    pkgs.lispPackages.quicklisp
    pkgs.tdrop
    pkgs.libreoffice
    pkgs.inotify-tools

    pkgs.htop
    pkgs.tty-clock

    # pkgs.nerdfonts
    pkgs.jre8
    pkgs.jdk8
    pkgs.mpv
    pkgs.deluge
    pkgs.sqls
    #pkgs.haskell-language-server
    #pkgs.ghc
    pkgs.gnome.zenity
    pkgs.remmina
    pkgs.pamixer
    pkgs.barrier
    pkgs.obs-studio
    # my-nur.ncpamixer-git
    pkgs.dbeaver
    pkgs.strawberry
    pkgs.vscode-with-extensions
    pkgs.sonic-pi
    pkgs.gnumake
    pkgs.source-code-pro
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.zoom-us
    pkgs.font-awesome
    pkgs.pulsemixer
    pkgs.dfeet
    pkgs.comma
    pkgs.hexchat
    pkgs.wineWowPackages.staging
    pkgs.winetricks
    pkgs.chromium
    pkgs.lutris
    pkgs.mpc_cli
    pkgs.gh
    pkgs.dotnet-sdk
    pkgs.soundkonverter
    pkgs.bottles
    pkgs.libunwind
    pkgs.lua53Packages.luarocks
    pkgs.sumneko-lua-language-server
    pkgs.ripgrep
    pkgs.sqlite
    pkgs.wordnet
    pkgs.prismlauncher
    pkgs.protontricks
    pkgs.proton-caller
    pkgs.spotify
    pkgs.gamescope
    # etterna

    #lol-launchhelper
  ];

  home.sessionVariables = { DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox"; };

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

  programs.exa = {
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
  services.random-background = {
    enable = true;
    enableXinerama = true;
    display = "fill";
    imageDirectory = "%h/Pictures/Backgrounds/Active";
    interval = "1h";
  };

  services.unclutter = { enable = true; };
  services.lorri = { enable = true; };

  services.picom = {
    enable = true;
    shadow = false;
    shadowOffsets = [ (-12) (-12) ];
    vSync = false;
    fade = true;
    fadeDelta = 2;

    wintypes = {
      tooltip = {
        fade = true;
        shadow = false;
        focus = true;
        full-shadow = false;
      };
      dock = { shadow = false; };
      dnd = { shadow = false; };
      popup_menu = { shadow = false; };
      dropdown_menu = { shadow = false; };
    };

    settings = {
      corner-radius = 1;
      rounded-corners-exclude =
        [ "window_type = 'dock'" "window_type = 'desktop'" ];
    };
  };

  services.dunst = {
    enable = false;

    settings = {
      global = {
        format = "<b>%s</b>\\n\\n%b";
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        geometry = "500x20-30+20";
        follow = "keyboard";
        padding = "16";
        ignore_newline = "no";
        horizontal_padding = "25";
        align = "right";
        word_wrap = "yes";
        markup = "full";
        allow_markup = "yes";
        timeout = 10;
        frame_width = 4;
        frame_color = "#8e24aa";
        corner_radius = 2;
        icon_position = "left";
        show_indicators = true;
        indicate_hidden = false;
      };

      urgency_normal = { background = "#141C21"; };
      urgency_critical = { background = "#FF5250"; };
    };
  };

  services.mopidy = {
    enable = true;
    extensionPackages = [
      (pkgs.mopidy-ytmusic.overrideAttrs (old: rec {
        version = "0.3.6";
        src = pkgs.python3Packages.fetchPypi {
          inherit version;
          pname = "Mopidy-YTMusic";
          sha256 = "nBNOTmi/mgPzZXVD7G0xfvvvyVChERWB/bjlvaTvrsU=";
        };
        postPatch =
          "	substituteInPlace setup.py \\\n	--replace 'ytmusicapi>=0.22.0,<0.23.0' 'ytmusicapi>=0.22.0'\n";
      }))
      pkgs.mopidy-mpd
      pkgs.mopidy-mpris
      pkgs.mopidy-scrobbler
      pkgs.mopidy-local
      pkgs.mopidy-mpris
    ];

    settings = {
      mpd = {
        enabled = true;
        command_blacklist = [ ];
      };

      youtube = { enabled = true; };

      ytmusic = {
        enabled = false;
        auth_json = "${config.xdg.configHome}/mopidy/auth.json";
      };

      scrobbler = {
        username = "alphinaud";
        password = "9WvdNfXMTvv%eia@N6qA";
      };

      mpris = { enabled = true; };

      local = {
        enabled = true;
        library = "json";
        media_dir = "/mnt/hdd/music";
        scan_timeout = 1000;
        scan_flush_threshold = 1000;
        excluded_file_extensions = [
          ".directory"
          ".html"
          ".jpeg"
          ".jpg"
          ".log"
          ".nfo"
          ".pdf"
          ".png"
          ".txt"
          ".zip"
          ".cue"
          ".log"
        ];
      };
    };

    # extraConfigFiles = [ "~/.config/mopidy/extra.conf" ];
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

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };

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
      };
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

  programs.beets = { enable = true; };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
