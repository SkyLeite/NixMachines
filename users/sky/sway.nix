{ config, pkgs, lib, ... }:

let i3 = config.xsession.windowManager.i3;
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = i3.config.modifier;
      terminal = i3.config.terminal;
      fonts = i3.config.fonts;
      colors = i3.config.colors;
      gaps = i3.config.gaps;
      input = { "*" = { xkb_file = builtins.toString ./us-br.xkb; }; };
      keybindings = i3.config.keybindings;
      assigns = i3.config.assigns;
      window = i3.config.window;
      startup = [
        { command = "flameshot"; }
        {
          command = "sh ../nixpkgs/screens.sh";
          always = true;
        }
      ];
    };
  };
}
