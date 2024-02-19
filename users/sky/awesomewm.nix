{ config, pkgs, lib, ... }: {
  xsession.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [ luarocks luadbi-mysql ];
    package = pkgs.awesome-git.override {
      lua = pkgs.lua53Packages.lua;
      gtk3Support = true;
    };
  };

  # Theme-specific packages
  home.packages = with pkgs; [
    dmenu
    scrot
    unclutter-xfixes
    xsel
    xss-lock
    i3lock-color
    lua-language-server
    xorg.xev
  ];
}
