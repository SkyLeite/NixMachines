{ config, pkgs, lib, ... }:

let
  cfg = config.programs.skymacs;
in
{
  options.programs.skymacs = {
    enable = lib.mkEnableOption "Skymacs";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.emacs29;
    };

    enableDoom = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    services.emacs = {
      enable = true;
      client.enable = true;
      defaultEditor = true;
      startWithUserSession = true;
    };

    programs.emacs = lib.mkIf cfg.enable {
      enable = true;
      package = cfg.package;
      extraPackages = epkgs: with epkgs; [
        magit
        which-key
        evil
	projectile
	perspective
	magit
	format-all
	modus-themes
	neotree
	envrc
	popwin

	# Helm
	helm
	helm-fuzzy

	# Org Mode
	org
	org-modern
	org-ql
	orgit
	helm-org
	org-roam

	# Company
	company
	company-quickhelp
	company-quickhelp-terminal

        # Evil packages
        evil-surround
        evil-snipe
        evil-smartparens
	evil-collection
	evil-org

        # Language modes
        nix-ts-mode

	treesit-grammars.with-all-grammars
        pkgs.fd
      ];
    };

    home.packages = [
      pkgs.bqn386
    ];

    fonts.fontconfig.enable = true;

    xdg.configFile."emacs/init.el" = {
      source = ./init.el;
    };
  };
}
