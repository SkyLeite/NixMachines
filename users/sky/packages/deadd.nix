{ config, pkgs, lib, ... }:

let deadd = pkgs.deadd-notification-center;
in {
  home.packages = [ deadd ];

  systemd.user.services = {
    deadd-notification-center = {
      Unit = { Description = "Deadd Notification Center"; };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${deadd}/bin/deadd-notification-center";
        Restart = "always";
        RestartSec = 10;
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };

  xdg.configFile = {
    "deadd.conf" = {
      target = "deadd/deadd.conf";
      text = ''
        # vim:set noet sts=0 sw=8 ts=8 ft=toml:
        [notification-center]

        # Hide the notification center when the mouse leaves the window
        # hideOnMouseLeave = True
        hideOnMouseLeave = false

        # Margin at the top of the notification center in pixels. This can be
        # used to avoid overlap between the notification center and bars such
        # as polybar or i3blocks.
        marginTop = 0

        # Margin at the bottom of the notification center in pixels.
        marginBottom = 0

        # Margin to the right of the notification center in pixels.
        marginRight = 0


        # Width of the notification center in pixels.
        width = 500

        # Monitor on which the notification center will be printed.
        monitor = 1

        # If true, the notification center will open on the screen, on which the
        # mouse is
        followMouse = false


        # (Optional) Command to run at startup.  This can be used to setup
        # button states.
        # startupCommand = "deadd-notification-center-startup"

        # If newFirst is set to true, newest notifications appear on the top
        # of the notification center. Else, notifications stack, from top to
        # bottom.
        newFirst = true

        # If useActionIcons is set to true, Action Buttons can show Icon
        useActionIcons = true

        # If true, the transient field in notifications will be ignored and
        # the notification will be persisted in the notification center anyways
        ignoreTransient = false

        # If true, markup (<u>, <i>, <b>, <a>) will be displayed properly
        useMarkup = true

        # If true, html entities (&#38; for &, &#37; for %, etc) will be parsed
        # properly. This is useful for chromium-based apps, which tend to send
        # these in notifications.
        parseHtmlEntities = true

        # If set to true, the parameter noClosedMsg can be set on
        # notifications. If noClosedMsg is set to true on a notification,
        # DBUS NotificationClosed messages will not be send for this
        # notification.
        configSendNotiClosedDbusMessage = false

        # If set to true: If no icon is passed by the app_icon parameter
        # and no application "desktop-entry"-hint is present, the notification
        # center will try to guess the icon from the application name (if present).
        # Default is true.
        guessIconFromAppname = true

        # See section "Notification based scripting" for an explanation
        #match = "title=Abc;body=abc":"app=notify-send"
        #modify = "transient=false"
        #run = "":"killall notify-send"

        [notification-center-notification-popup]

        # Default timeout used for notifications in milli-seconds.  This can
        # be overwritten with the "-t" option (or "--expire-time") of the
        # notify-send command.
        notiDefaultTimeout = 10000

        # Margin above notifications (in pixels). This can be used to avoid
        # overlap between notifications and a bar such as polybar or i3blocks.
        distanceTop = 50

        # Margin on the right of the notification (in pixels).
        distanceRight = 50

        # Vertical distance between 2 notifications (in pixels).
        distanceBetween = 20

        # Width of the notifications.
        width = 300

        # Monitor on which the notification will be printed.
        monitor = 1

        # If true, the notifications will open on the screen, on which the
        # mouse is
        followMouse = false

        # The display size of the application icons in the notification
        # pop-ups and in the notification center
        iconSize = 20

        # The maximal display size of images that are part of notifications
        # for notification pop-ups and in the notification center
        maxImageSize = 100

        # The margin around the top, bottom, left, and right of notification
        # images. Applies to popup notifications and in-center notifications.
        imageMarginTop = 15
        imageMarginBottom = 15
        imageMarginLeft = 15
        imageMarginRight = 0

        # Truncates notification bodies with '...' at the specified number of
        # lines. If -1 is specified, the body text will not be truncated.
        # Applies only to popup notifications
        shortenBody = 5

        # The mouse button for closing a popup. Must be either "mouse1",
        # "mouse2", "mouse3", "mouse4", or "mouse5"
        dismissButton = mouse3

        # The mouse button for opening a popup with the default action.
        # Must be either "mouse1", "mouse2", "mouse3", "mouse4", or "mouse5"
        defaultActionButton = mouse1

        [buttons]
        ### This section describes the configurable buttons within the
        ### notification center and NOT the buttons that appear in the
        ### notifications

        # Note: If you want your buttons in the notification center to be
        #       squares you should verify that the following equality holds:
        #       [notification-center]::width
        #          == [buttons]::buttonsPerRow * [buttons]::buttonHeight
        #             + ([buttons]::buttonsPerRow + 1) * [buttons]::buttonMargin

        # Numbers of buttons that can be drawn on a row of the notification
        # center.
        buttonsPerRow = 5

        # Height of buttons in the notification center (in pixels).
        buttonHeight = 60

        # Horizontal and vertical margin between each button in the
        # notification center (in pixels).
        buttonMargin = 2

        # Labels written on the buttons in the notification center. Labels
        # should be written between quotes and separated by a colon. For
        # example:
        labels = "VPN":"Bluetooth":"Wifi":"Screensaver"

        # Each label is represented as a clickable button in the notification
        # center. The commands variable below define the commands that should
        # be launched when the user clicks on the associated button.  There
        # should be the same number of entries in `commands` and in `labels`
        commands = "sudo vpnToggle":"bluetoothToggle":"wifiToggle":"screensaverToggle"
      '';
    };

    "deadd.css" = {
      target = "deadd/deadd.css";
      text = ''

        /* Notification center */

        .blurredBG, #main_window, .blurredBG.low, .blurredBG.normal {
            background: rgba(255, 255, 255, 0.5);
        }

        .noti-center.time {
            font-size: 32px;
        }

        /* Notifications */

        .title {
            font-weight: bold;
            font-size: 16px;
        }

        .appname {
            font-size: 12px;
        }

        .time {
            font-size: 12px;
        }

        .blurredBG.notification {
            background:  rgba(255, 255, 255, 0.4);
        }

        .blurredBG.notification.critical {
            background: rgba(255, 0, 0, 0.5);
        }

        .notificationInCenter.critical {
            background: rgba(155, 0, 20, 0.5);
        }

        /* Labels */

        label {
            color: #322;
        }

        label.notification {
            color: #322;
        }

        label.critical {
            color: #000;
        }
        .notificationInCenter label.critical {
            color: #000;
        }


        /* Buttons */

        button {
            background: transparent;
            color: #322;
            border-radius: 3px;
            border-width: 0px;
            background-position: 0px 0px;
            text-shadow: none;
        }

        button:hover {
            border-radius: 3px;
            background: rgba(0, 20, 20, 0.2);
            border-width: 0px;
            border-top: transparent;
            border-color: #f00;
            color: #fee;
        }


        /* Custom Buttons */

        .userbutton {
            background: rgba(20,0,0, 0.15);
        }

        .userbuttonlabel {
            color: #222;
            font-size: 12px;
        }

        .userbutton:hover {
            background: rgba(20, 0, 0, 0.2);
        }

        .userbuttonlabel:hover {
            color: #111;
        }

        button.buttonState1 {
            background: rgba(20,0,0,0.5);
        }

        .userbuttonlabel.buttonState1 {
            color: #fff;
        }

        button.buttonState1:hover {
            background: rgba(20,0,0, 0.4);
        }

        .userbuttonlabel.buttonState1:hover {
            color: #111;
        }

        button.buttonState2 {
            background: rgba(255,255,255,0.3);
        }

        .userbuttonlabel.buttonState2 {
            color: #111;
        }

        button.buttonState2:hover {
            background: rgba(20,0,0, 0.3);
        }

        .userbuttonlabel.buttonState2:hover {
            color: #000;
        }


        /* Images */

        image.deadd-noti-center.notification.image {
            margin-left: 20px;
        }
      '';
    };
  };
}
