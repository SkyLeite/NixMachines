{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.home-assistant-oci;
in {
  imports = [ ../modules/chaos-service.nix ];

  options = {
    services.home-assistant-oci = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Home assistant
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    chaos.services.home-assistant = {
      enable = true;
      port = 8123;
    };

    virtualisation = {
      libvirtd = {
        enable = true;
        # Used for UEFI boot of Home Assistant OS guest image
        qemuOvmf = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # For virt-install
      virt-manager

      # For lsusb
      usbutils
    ];

    #networking.defaultGateway = "10.0.0.1";
    #networking.bridges.br0.interfaces = [ "enp2s0" ];
    #networking.interfaces.br0 = {
    #  useDHCP = false;
    #  ipv4.addresses = [{
    #    "address" = "10.0.0.5";
    #    "prefixLength" = 24;
    #  }];
    #};

    # systemd.services.home-assistant = {
    #   startLimitIntervalSec = 14400;
    #   startLimitBurst = 10;
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "docker.service" "docker.socket" ];
    #   requires = [ "docker.service" "docker.socket" ];
    #   preStop = "${pkgs.docker}/bin/docker stop home-assistant";
    #   reload = "${pkgs.docker}/bin/docker restart home-assistant";
    #   serviceConfig = {
    #     ExecStartPre = "-${pkgs.docker}/bin/docker rm -f home-assistant";
    #     ExecStopPost = "-${pkgs.docker}/bin/docker rm -f home-assistant";
    #     TimeoutStartSec = 0;
    #     TimeoutStopSec = 120;
    #     Restart = "on-abnormal";
    #     ExecStart = ''
    #       ${pkgs.docker}/bin/docker run \
    #         --name home-assistant \
    #         --privileged \
    #         --restart=unless-stopped \
    #         -e TZ=America/Sao_Paulo \
    #         -v /srv/home-assistant/config:/config \
    #         --network=host \
    #         ghcr.io/home-assistant/home-assistant:stable
    #     '';
    #   };
    # };
  };
}
