{ pkgs, lib }:

# profiles:
# [profile]
#
# profile:
# { name: string
# , default: bool(false)
# , layout: layout
# , onActive : string -- bash command to be run when profile becomes active
# }
#
# layout:
# { [output-name: string]: output }
#
# output:
# { enabled: bool(true)
# , width: int
# , height: int
# , refreshRate: int(60)
# , position: { x: int, y: int }
# , flipped: bool(false)
# , transformDeg: int(0) }

let
  monitors = {
    main = {
      width = 5120;
      height = 1440;
      refreshRate = 239.761;
      primary = true;
    };

    secondary = {
      width = 1920;
      height = 1080;
      refreshRate = 144;
      primary = false;
    };

    tv = {
      width = 3840;
      height = 2160;
      refreshRate = 60;
      primary = false;
    };
  };

  ports = {
    "DP-1" = monitors.main;
    "DP-2" = monitors.secondary;
    "DP-3" = monitors.secondary;
    "HDMI-A-1" = monitors.tv;
  };

  monitorPorts = {
    tv = "HDMI-A-1";
    main = "DP-1";
  };

  profiles = [
    {
      name = "main";
      default = true;
      layout = {
        "DP-1" = monitors.main // {
          enabled = true;
          position = {
            x = 0;
            y = 1080;
          };
        };

        "DP-2" = monitors.secondary // {
          enabled = true;
          position = {
            x = 0;
            y = 0;
          };
        };

        "DP-3" = monitors.secondary // {
          enabled = true;
          width = 1920;
          height = 1080;
          refreshRate = 144;
          position = {
            x = 1920;
            y = 0;
          };
        };

        "HDMI-A-1" = monitors.tv // {
          enabled = false;
          position = {
            x = 0;
            y = 0;
          };
        };
      };
    }
    {
      name = "tv";
      default = false;
      onActive = lib.concatStringsSep "&&" [
        "${pkgs.gtk3}/bin/gtk-launch --display=:0 'Steam (Gamescope 4k)'"
        ''
          ${pkgs.wlrctl}/bin/wlrctl toplevel waitfor title:"Steam Big Picture Mode"''
        "${pkgs.sway}/bin/swaymsg '[title=\"^Steam Big Picture Mode$\"] focus, move to workspace tv'"
      ];
      layout = {
        "DP-1" = monitors.main // {
          enabled = true;
          position = {
            x = 0;
            y = 2160;
          };
        };

        "DP-2" = monitors.secondary // {
          enabled = false;
          position = {
            x = 0;
            y = 0;
          };
        };

        "DP-3" = monitors.secondary // {
          enabled = false;
          position = {
            x = 1920;
            y = 0;
          };
        };

        "HDMI-A-1" = monitors.tv // {
          enabled = true;
          position = {
            x = 0;
            y = 0;
          };
        };
      };
    }
  ];

  defaultProfile = builtins.elemAt
    (builtins.filter (profile: profile.default == true) profiles) 0;

  layoutToSwayLayout = builtins.mapAttrs (outputName: output:
    {
      mode = "${toString output.width}x${toString output.height}@${
          toString output.refreshRate
        }Hz";
      pos = "${toString output.position.x} ${toString output.position.y}";
    } // (if output.enabled then { enable = ""; } else { disable = ""; }));

  layoutToSwayCommand = layout:
    lib.trivial.pipe layout [
      layoutToSwayLayout

      (builtins.mapAttrs (outputName: swayOutput:
        "output ${outputName} ${
          if lib.hasAttrByPath [ "enable" ] swayOutput then
            "enable"
          else
            "disable"
        } mode ${swayOutput.mode} pos ${swayOutput.pos}"))

      builtins.attrValues
      (lib.concatStringsSep "; ")
    ];

  outputToXrandrFlags = outputName: output:
    "--output ${outputName} --mode ${toString output.width}x${
      toString output.height
    } --pos ${toString output.position.x}x${
      toString output.position.y
    } --rotate normal";

  layoutToXrandrFlags = layout:
    lib.trivial.pipe layout [
      (builtins.mapAttrs outputToXrandrFlags)
      builtins.attrValues
      (lib.concatStringsSep " ")
    ];

  profileToXrandrCommandCase = profile: ''
    "${profile.name}")
      xrandr ${layoutToXrandrFlags profile.layout}
    ;;
  '';

  profileToBashCase = profile: ''
    "${profile.name}")
      swaymsg "${layoutToSwayCommand profile.layout}" && sleep 2 && swaymsg "${
        layoutToSwayCommand profile.layout
      }" ${
        if lib.hasAttrByPath [ "onActive" ] profile then
          "&& sleep 2 && ${profile.onActive}"
        else
          ""
      }
      ;;
  '';
in {
  inherit profiles monitors ports monitorPorts defaultProfile;

  swayOutput = layoutToSwayLayout defaultProfile.layout;

  outputProfileScript = pkgs.writeShellScriptBin "outputProfile" ''
    case $1 in
      ${
        lib.trivial.pipe profiles [
          (map profileToBashCase)
          (lib.concatStringsSep "\n")
        ]
      }

      *)
        echo "Profile $1 not found :("
        ;;

    esac
  '';

  outputArandrProfileScript = pkgs.writeShellScriptBin "arandrProfile" ''
    case $1 in
      ${
        lib.trivial.pipe profiles [
          (map profileToXrandrCommandCase)
          (lib.concatStringsSep "\n")
        ]
      }

      *)
        echo "Profile $1 not found :("
        ;;

    esac
  '';

}
