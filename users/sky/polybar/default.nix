{ config, pkgs, ... }: {
  services.polybar = {
    enable = true;
    script = "SHELL=$(which sh) polybar top & SHELL=$(which sh) polybar top2 &";
    package = pkgs.polybar.override {
      i3Support = true;
      i3 = pkgs.i3;
      jsoncpp = pkgs.jsoncpp;
    };
    config = ./hack/config.ini;
  };
}
