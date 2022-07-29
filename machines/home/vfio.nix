{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.virt-manager
    pkgs.looking-glass-client
    pkgs.swtpm
    pkgs.win-virtio
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

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 alex qemu-libvirtd -"
  ];

  programs.dconf.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemuOvmf = true;
      qemuSwtpm = true;
      #qemuOvmfPackage = pkgs.OVMFFull;
      qemuVerbatimConfig = ''
        user = "sky"
        group = "kvm"
        cgroup_device_acl = [
            "/dev/input/by-id/usb-ZSA_Technology_Labs_Inc_ErgoDox_EZ_Glow-event-kbd",
            "/dev/input/by-id/usb-Logitech_G403_Prodigy_Gaming_Mouse_087838573135-event-mouse",
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
            "/dev/rtc","/dev/hpet", "/dev/sev"
        ]
      '';
    };
  };
}
