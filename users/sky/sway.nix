{ config, pkgs, lib, ... }:

let i3 = config.xsession.windowManager.i3;
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = i3.config.modifier;
      terminal = i3.config.terminal;
      fonts = i3.config.fonts;
      colors = i3.config.colors // rec {
        focused = {
          border = config.colorscheme.colors.base06;
          background = config.colorscheme.colors.base06;
          text = config.colorscheme.colors.base00;
          childBorder = config.colorscheme.colors.base06;
          indicator = config.colorscheme.colors.base04;
        };

        focusedInactive = {
          border = config.colorscheme.colors.base00;
          background = config.colorscheme.colors.base00;
          text = config.colorscheme.colors.base06;
          childBorder = config.colorscheme.colors.base00;
          indicator = config.colorscheme.colors.base00;
        };

        unfocused = focusedInactive;
      };

      output = {
        "*" = { background = "${config.variables.wallpaper} fill"; };
      };

      gaps = i3.config.gaps;
      input = { "*" = { xkb_file = builtins.toString ./us-br.xkb; }; };
      keybindings = i3.config.keybindings // {
        "Print" =
          "exec ${pkgs.flameshot}/bin/flameshot gui --raw | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png";
      };
      assigns = i3.config.assigns;
      window = i3.config.window // {
        titlebar = true;
        border = 5;
        commands = [ ];
      };
      startup = [
        { command = "flameshot"; }
        {
          command = "sh ../nixpkgs/screens.sh";
          always = true;
        }
        {
          command =
            "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK";
        }
        {
          command =
            "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";
        }
      ];
    };
  };

  home.packages = [ pkgs.swaynotificationcenter ];

  xdg.configFile."swaync/style.css" = {
    source = ./swaync.css;
    onChange = "${pkgs.swaynotificationcenter}/bin/swaync-client --reload-css";
  };

  xdg.configFile."swaync/config.json" = let
    swayncConfig = {
      "$schema" =
        "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
      positionX = "center";
      positionY = "top";
      layer = "top";
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 600;
      control-center-height = 800;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      scripts = {
        testing-script = {
          exec = "${pkgs.coreutils}/bin/echo 'Something entirely different'";
          urgency = "Normal";
        };
      };
      notification-visibility = {
        example-name = {
          state = "muted";
          urgency = "Low";
          app-name = "Spotify";
        };
      };
      widgets = [ "title" "dnd" "notifications" ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = { text = "Do Not Disturb"; };
        label = {
          max-lines = 5;
          text = "Label Text";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };
  in {
    text = builtins.toJSON swayncConfig;
    onChange =
      "${pkgs.swaynotificationcenter}/bin/swaync-client --reload-config";
  };
}
