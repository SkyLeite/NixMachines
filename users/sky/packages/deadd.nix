{ config, pkgs, lib, ... }:

let deadd = pkgs.deadd-notification-center;
in {
  home.packages = [ deadd ];

  systemd.user.services = {
    deadd-notification-center = {
      Unit = {
        Description = "Deadd Notification Center";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${deadd}/bin/deadd-notification-center";
        Restart = "always";
        RestartSec = 10;
      };

      Install = { WantedBy = [ "multi-user.target" ]; };
    };
  };
}
