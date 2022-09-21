{ pkgs, config, lib, ... }:

let
  emacsPkg = pkgs.emacs28NativeComp;
  emacsD = "${config.home.homeDirectory}/.emacs.d";
  emacsBinDirectory = "${emacsD}/bin";
  doomSyncCommand =
    "${emacsBinDirectory}/doom sync --force && ${pkgs.systemd}/bin/systemctl --user restart emacs";
in {
  programs.emacs = {
    enable = true;
    package = emacsPkg;
  };

  services.emacs = {
    enable = false;
    package = emacsPkg;
    client.enable = true;
    defaultEditor = true;
    #socketActivation.enable = true;
  };

  home.sessionVariables = { EDITOR = "${emacsPkg}/bin/emacs"; };

  home.activation = {
    installDoom = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Clone doom emacs
      if [ ! -e ${emacsD}/.local ]; then
        ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs ${emacsD}
      fi
    '';
  };

  home.sessionPath = [ emacsBinDirectory ];

  # Copy Doom's config files over
  home.file = {
    ".doom.d/config.el" = { source = ./doom.d/config.el; };
    ".doom.d/init.el" = {
      source = ./doom.d/init.el;
      onChange = doomSyncCommand;
    };
    ".doom.d/packages.el" = {
      source = ./doom.d/packages.el;
      onChange = doomSyncCommand;
    };
  };
}
