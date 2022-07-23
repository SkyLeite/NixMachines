{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.dashy;
in {
  options = {
    services.dashy = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Dashy
        '';
      };

      config = mkOption {
        type = types.submodule {
          options = {
            pageInfo = mkOption {
              type = types.submodule {
                options = {
                  title = mkOption { type = types.str; };
                  description = mkOption {
                    type = with types; nullOr str;
                    default = null;
                  };
                  footerText = mkOption {
                    type = with types; nullOr str;
                    default = null;
                  };
                  logo = mkOption {
                    type = with types; nullOr str;
                    default = null;
                  };
                };
              };
            };

            sections = mkOption {
              type = with types;
                listOf (submodule {
                  options = {
                    name = mkOption { type = types.str; };
                    icon = mkOption {
                      type = with types; nullOr str;
                      default = null;
                    };
                    items = mkOption {
                      default = [ ];
                      type = with types;
                        listOf (submodule {
                          options = {
                            title = mkOption { type = types.str; };
                            description = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            url = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            icon = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            target = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            hotkey = mkOption {
                              type = with types; nullOr (ints.between 0 9);
                              default = null;
                            };
                            tags = mkOption {
                              type = with types; nullOr (listOf str);
                              default = null;
                            };
                            statusCheck = mkOption {
                              type = with types; nullOr bool;
                              default = null;
                            };
                            statusCheckUrl = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            statusCheckHeaders = mkOption {
                              type = with types; nullOr attrs;
                              default = null;
                            };
                            statusCheckAllowInsecure = mkOption {
                              type = with types; nullOr bool;
                              default = null;
                            };
                            statusCheckAcceptCodes = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            statusCheckMaxRedirects = mkOption {
                              type = with types; nullOr int;
                              default = null;
                            };
                            color = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            backgroundColor = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            provider = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                            displayData = mkOption {
                              type = with types; nullOr str;
                              default = null;
                            };
                          };
                        });
                    };
                  };
                });
            };
          };
        };
        default = { };
        description = ''
          Dashy's configuration
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    chaos.services.root = {
      enable = true;
      port = 8080;
    };

    systemd.services.dashy = let
      format = pkgs.formats.yaml { };
      config = format.generate "dashy.yml" cfg.config;
    in {
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;
      restartIfChanged = true;
      after = [ "docker.service" "docker.socket" ];
      requires = [ "docker.service" "docker.socket" ];
      preStop = "${pkgs.docker}/bin/docker stop dashy";
      reload = "${pkgs.docker}/bin/docker restart dashy";
      serviceConfig = {
        ExecStartPre = "-${pkgs.docker}/bin/docker rm -f dashy";
        ExecStopPost = "-${pkgs.docker}/bin/docker rm -f dashy";
        TimeoutStartSec = 0;
        TimeoutStopSec = 120;
        Restart = "always";
        ExecStart = ''
          ${pkgs.docker}/bin/docker run \
            --rm \
            --name=dashy \
            -p 8080:80 \
            -v ${config}:/app/public/conf.yml \
            lissy93/dashy:latest
        '';
      };
    };
  };
}
