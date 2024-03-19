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

    home.packages = with pkgs.tree-sitter-grammars; [
    ];

    programs.emacs = lib.mkIf cfg.enable {
      enable = true;
      package = cfg.package;
      extraPackages = epkgs: with epkgs; [
        magit
        which-key
        evil
        apheleia

        # Evil packages
        evil-surround
        evil-snipe
        evil-smartparens

        # Language modes
        nix-ts-mode

        pkgs.tree-sitter-grammars.tree-sitter-elm
        pkgs.tree-sitter-grammars.tree-sitter-rust
        pkgs.tree-sitter-grammars.tree-sitter-python
        pkgs.tree-sitter-grammars.tree-sitter-go
        pkgs.tree-sitter-grammars.tree-sitter-nix
        pkgs.tree-sitter-grammars.tree-sitter-html
        pkgs.tree-sitter-grammars.tree-sitter-css
        pkgs.tree-sitter-grammars.tree-sitter-scss
        pkgs.tree-sitter-grammars.tree-sitter-json
        pkgs.tree-sitter-grammars.tree-sitter-yaml
        pkgs.tree-sitter-grammars.tree-sitter-javascript
        pkgs.tree-sitter-grammars.tree-sitter-typescript
      ];
    };
  };
}
