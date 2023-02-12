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
      keybindings = i3.config.keybindings;
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
}
