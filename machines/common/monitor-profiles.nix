{ pkgs, lib }:

# profiles:
# [profile]
#
# profile:
# { name: string
# , default: bool(false)
# , layout: layout}
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
  profiles = [
    {
      name = "main";
      default = true;
      layout = {
        "DP-1" = {
          enabled = true;
          width = 5120;
          height = 1440;
          refreshRate = 239.761;
          position = {
            x = 0;
            y = 1080;
          };
          flipped = false;
          transformDeg = 0;
        };

        "DP-2" = {
          enabled = true;
          width = 1920;
          height = 1080;
          refreshRate = 144;
          position = {
            x = 0;
            y = 0;
          };
          flipped = false;
          transformDeg = 0;
        };

        "DP-3" = {
          enabled = true;
          width = 1920;
          height = 1080;
          refreshRate = 144;
          position = {
            x = 1920;
            y = 0;
          };
          flipped = false;
          transformDeg = 0;
        };

        "HDMI-A-1" = {
          enabled = false;
          width = 3840;
          height = 2160;
          refreshRate = 60;
          position = {
            x = 0;
            y = 0;
          };
          flipped = false;
          transformDeg = 0;
        };
      };
    }
    {
      name = "tv";
      default = false;
      layout = {
        "DP-1" = {
          enabled = true;
          width = 5120;
          height = 1440;
          refreshRate = 240;
          position = {
            x = 0;
            y = 2160;
          };
          flipped = false;
          transformDeg = 0;
        };

        "DP-2" = {
          enabled = false;
          width = 1920;
          height = 1080;
          refreshRate = 144;
          position = {
            x = 0;
            y = 0;
          };
          flipped = false;
          transformDeg = 0;
        };

        "DP-3" = {
          enabled = false;
          width = 1920;
          height = 1080;
          refreshRate = 144;
          position = {
            x = 1920;
            y = 0;
          };
          flipped = false;
          transformDeg = 0;
        };

        "HDMI-A-1" = {
          enabled = true;
          width = 3840;
          height = 2160;
          refreshRate = 60;
          position = {
            x = 0;
            y = 0;
          };
          flipped = false;
          transformDeg = 0;
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

  profileToBashCase = profile: ''
    "${profile.name}")
      swaymsg "${layoutToSwayCommand profile.layout}" && sleep 2 && swaymsg "${
        layoutToSwayCommand profile.layout
      }"
      ;;
  '';
in {
  inherit profiles defaultProfile;

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
}
