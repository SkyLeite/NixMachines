{ config, pkgs, ... }: {
  services.polybar = {
    enable = true;
    script = "SHELL=$(which sh) polybar mybar &";
    # package = pkgs.polybar.override {
    #   i3Support = true;
    #   i3 = pkgs.i3;
    #   jsoncpp = pkgs.jsoncpp;
    # };
    package = pkgs.polybarFull;
    config = ./config.ini;
  };

  # xdg.configFile."polybar".source = pkgs.symlinkJoin {
  #   name = "polybar-symlinks";
  #   paths = let
  #     polybar-themes = pkgs.fetchFromGitHub {
  #       owner = "adi1090x";
  #       repo = "polybar-themes";
  #       rev = "c80ad81f1d9656ac0e2b9739abcf8e58df7da961";
  #       sha256 = "sha256-Uo/Q7lxbG3dTprAdNNpdyqFgzhleBlV3MieOC8wEkZ0=";
  #     };
  #   in [ "${polybar-themes}/fonts" "${polybar-themes}/simple" ];
  # };
}
