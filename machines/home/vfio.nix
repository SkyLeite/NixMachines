{ config, pkgs, ... }:

let

  lookingGlassDesktopItem = pkgs.makeDesktopItem {
    name = "Looking Glass";
    exec =
      "${pkgs.looking-glass-client}/bin/looking-glass-client -s false -K 144";
    comment = "User Defined Looking Glass Client";
    desktopName = "Looking Glass";
    categories = [ "Game" ];
  };
in {

  environment.systemPackages = [
    pkgs.virt-manager
    pkgs.looking-glass-client
    pkgs.swtpm
    pkgs.win-virtio
    lookingGlassDesktopItem
  ];

  boot = {
    kernelParams = [ "amd_iommu=on" ];
    kernelModules = [
      "vendor-reset"
      "vfio_virqfd"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
      "amdgpu"
    ];
    extraModprobeConfig = "options vfio-pci ids=1002:699f,1002:aae0";
    extraModulePackages = [
      config.boot.kernelPackages.vendor-reset
      config.boot.kernelPackages.cpupower
    ];

    postBootCommands = ''
      echo 'device_specific' > /sys/bus/pci/devices/0000\:05\:00.0/reset_method
    '';
  };

  systemd.tmpfiles.rules =
    [ "f /dev/shm/looking-glass 0660 alex qemu-libvirtd -" ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  programs.dconf.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        ovmf.enable = true;
        swtpm.enable = true;

        package = pkgs.qemu_kvm.overrideAttrs (oldAttrs: rec {
          patches = [
            (pkgs.fetchpatch {
              url =
                "https://gist.githubusercontent.com/SkyLeite/eb12aec4298c4f06c8a05bb0c70e242f/raw/7ddcd42a895b97e15509430f6d9269d6e56402aa/qemu-stop-capturing-evdev-on-boot.diff";
              sha256 = "sha256-T2gM6VtdJSI6zbNaG2qV8Dxn30vruplxjl2shx7djPE=";
            })
          ];
        });

        verbatimConfig = ''
          user = "sky"
          group = "kvm"
          cgroup_device_acl = [
              "/dev/input/by-id/usb-ZSA_Technology_Labs_Inc_ErgoDox_EZ_Glow-event-kbd",
              "/dev/input/by-id/usb-Logitech_G403_Prodigy_Gaming_Mouse_087838573135-event-mouse",
              "/dev/input/by-id/uinput-persist-keyboard0",
              "/dev/input/by-id/uinput-persist-keyboard1",
              "/dev/input/by-id/uinput-persist-keyboard2",
              "/dev/input/by-id/uinput-persist-keyboard3",
              "/dev/input/by-id/uinput-persist-mouse0",
              "/dev/input/by-id/uinput-persist-mouse1",
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
              "/dev/rtc","/dev/hpet", "/dev/sev"
          ]
        '';
      };
    };
  };
}
