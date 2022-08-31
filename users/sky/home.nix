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
in {
  imports = [
    ./polybar
    ./i3.nix
    ./tmux.nix
    ./neovim.nix
    ./scripts/gui.nix
    ./packages/deadd.nix
    ./packages/xborder.nix
    ./packages/noisetorch.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    pkgs.gimp-with-plugins
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
    pkgs.lutris
    pkgs.niv
    pkgs.polymc
    pkgs.discord-canary
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

    #lol-launchhelper
  ];

  home.sessionVariables = {
    EDITOR = "emacs";
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  programs.git = {
    enable = true;
    userName = "Sky";
    userEmail = "sky@leite.dev";
    extraConfig = { init = { defaultBranch = "main"; }; };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
  };
  programs.firefox = {
    enable = true;
    profiles.sky = {
      settings = {
        "browser.search.isUS" = false;
        "browser.bookmarks.showMobileBookmarks" = true;
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
    };
  };

  programs.ncmpcpp = {
    enable = false;
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
    shadow = true;
    shadowOffsets = [ (-12) (-12) ];
    vSync = false;
    fade = true;
    fadeDelta = 2;

    settings = {
      corner-radius = 10;
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
    extensionPackages =
      [ pkgs.mopidy-ytmusic pkgs.mopidy-mpd pkgs.mopidy-mpris ];
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

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sky";
  home.homeDirectory = "/home/sky";
  home.file = {
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
