{ config, pkgs, lib, ... }:
let
  mod = "Mod4";
  leftScreen = "DisplayPort-0";
  rightScreen = "DisplayPort-1";
  players = [ "mopidy" ];
  playerctlPlayers = "-p ${builtins.concatStringsSep "," players}";
in {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;
    config = {
      modifier = mod;
      bars = [ ];
      # bars = [{
      #   fonts = {
      #     names = [ "DejaVu Sans Mono" "Font Awesome 6 Free" ];
      #     size = 10.0;
      #   };
      #   position = "bottom";
      #   workspaceNumbers = true;
      #   workspaceButtons = true;
      #   statusCommand =
      #     "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-main.toml";
      # }];

      terminal = "alacritty";
      fonts = {
        names = [ "DejaVu Sans Mono, FontAwesome 6" ];
        style = "Bold Semi-Condensed";
        size = 9.0;
      };

      colors = {
        focused = {
          background = "#390d45";
          border = "#8e24aa";
          text = "#FFFFFF";
          childBorder = "#285577";
          indicator = "#2e9ef4";
        };
      };

      gaps = { inner = 12; };

      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec rofi -show drun -columns 3 -sidebar-mode";
        "${mod}+z" = "exec rofi -show emoji";
        "${mod}+Escape" = "exec rofi -show firefox";
        "${mod}+o" = "exit";
        "${mod}+x" = "exec ~/.emacs.d/bin/org-capture";
        "${mod}+g" =
          "exec tdrop -am -w 80% -h 45% -x 10% alacritty --class AlacrittyFloating";

        "${mod}+s" =
          "exec tdrop -am -w 50% -x 25% -y 25% alacritty -e pulsemixer";

        "${mod}+Shift+f" = "kill";
        "${mod}+Shift+y" = "restart";

        "${mod}+h" = "focus left";
        "${mod}+Shift+h" = "move left";
        "${mod}+j" = "focus down";
        "${mod}+Shift+j" = "move down";
        "${mod}+k" = "focus up";
        "${mod}+Shift+k" = "move up";
        "${mod}+l" = "focus right";
        "${mod}+Shift+l" = "move right";

        "${mod}+1" = "workspace 1";
        "${mod}+Shift+1" = "move workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+Shift+2" = "move workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+Shift+3" = "move workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+Shift+4" = "move workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+Shift+5" = "move workspace 5";

        "${mod}+0" = "workspace tv";
        "${mod}+Shift+0" = "move workspace tv";

        "${mod}+q" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+v" = "split vertical";
        "${mod}+b" = "split horizontal";

        "${mod}+Print" = "exec flameshot full -c";
        "Print" = "exec flameshot gui";

        "XF86AudioRaiseVolume" = "exec pamixer -i 10";
        "XF86AudioLowerVolume" = "exec pamixer -d 10";
        "${mod}+XF86AudioRaiseVolume" = "exec pamixer -i 1";
        "${mod}+XF86AudioLowerVolume" = "exec pamixer -d 1";
        "XF86AudioMute" =
          "exec amixer sset Master toggle && killall -USR1 i3blocks";

        "XF86AudioPlay" = "exec playerctl play-pause ${playerctlPlayers}";
        "XF86AudioPrev" = "exec playerctl previous ${playerctlPlayers}";
        "XF86AudioNext" = "exec playerctl next ${playerctlPlayers}";
      };

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = leftScreen;
        }
        {
          workspace = "2";
          output = leftScreen;
        }
        {
          workspace = "3";
          output = leftScreen;
        }
        {
          workspace = "4";
          output = leftScreen;
        }
        {
          workspace = "5";
          output = leftScreen;
        }

        {
          workspace = "1:Q";
          output = rightScreen;
        }
        {
          workspace = "2:W";
          output = rightScreen;
        }
        {
          workspace = "3:E";
          output = rightScreen;
        }
        {
          workspace = "4:R";
          output = rightScreen;
        }
        {
          workspace = "5:T";
          output = rightScreen;
        }
      ];

      # assigns = { "4" = [{ class = "^.gamescope-wrapped$"; }]; };

      startup = [
        {
          command = "systemctl --user start polybar";
          notification = false;
        }
        { command = "flameshot"; }
        {
          command = "sh ../nixpkgs/screens.sh";
          always = true;
        }
        {
          command =
            "${pkgs.polkit_gnome}/bin/polkit-gnome-authentication-agent-1";
          always = true;
        }
        # {
        #   command = ''
        #     ${pkgs.pipewire}/bin/pw-loopback --capture-props='node.target="alsa_input.pci-0000_0f_00.4.analog-stereo"'
        #   '';
        # }
      ];

      window = { border = 0; };

      window.commands = [
        {
          command = "floating enable";
          criteria = { title = "doom-capture"; };
        }
        {
          command = "border pixel 0";
          criteria = { class = "^.*"; };
        }

        {
          command = "floating enable";
          criteria = { instance = "yakuake"; };
        }

        {
          command = "floating enable";
          criteria = { class = "Pavucontrol"; };
        }

        {
          command = "floating enable";
          criteria = { class = "Blueman-manager"; };
        }

        {
          command = "floating enable";
          criteria = { class = ".zoom "; };
        }

        {
          command = "floating disable";
          criteria = {
            class = ".zoom ";
            title = "Zoom - (Free|Licensed) Account";
          };
        }

        {
          command = "floating disable";
          criteria = {
            class = ".zoom ";
            title = "Zoom Meeting";
          };
        }

        {
          command = "floating enable";
          criteria = { instance = "AlacrittyFloating"; };
        }

        {
          command = "floating enable";
          criteria = { instance = "origin.exe"; };
        }

        {
          command = "sticky enable";
          criteria = { title = "Picture-in-Picture"; };
        }
      ];
    };

  };

  programs.i3status-rust = {
    enable = true;

    bars = {
      main = {
        icons = "awesome6";
        blocks = [
          {
            block = "music";
            player = "spotify";
            format =
              " $icon {$combo.str(max_w:60,rot_interval:0.5) $prev $play $next |}";
          }
          {
            block = "disk_space";
            path = "/";
            format = " NVME $icon $available ";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "disk_space";
            path = "/mnt/hdd";
            format = " HDD $icon $available ";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "cpu";
            interval = 1;
            format = " $icon $barchart $utilization ";
          }
          {
            block = "memory";
            format =
              " $icon $mem_used.eng(prefix:M)/$mem_total.eng(prefix:M)($mem_total_used_percents.eng(w:2)) ";
          }
          { block = "amd_gpu"; }
          {
            block = "sound";
            max_vol = 100;
            headphones_indicator = true;
          }
          { block = "time"; }
        ];
      };
    };
  };
}
