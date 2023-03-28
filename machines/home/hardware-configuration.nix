# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, mesa-git-src, ... }:
let
  mesaGitApplier = base:
    base.mesa.overrideAttrs (fa: {
      version = "23.1.0-devel";
      src = mesa-git-src;
      buildInputs = fa.buildInputs
        ++ [ base.zstd base.libunwind base.lm_sensors ];
      mesonFlags = (lib.lists.remove "-Dgallium-rusticl=true" fa.mesonFlags)
        ++ [
          "-D android-libbacktrace=disabled"
        ]; # fails to find "valgrind.h" with 23.0+ codebase
    });

  mesa-bleeding = mesaGitApplier pkgs;
  lib32-mesa-bleeding = mesaGitApplier pkgs.pkgsi686Linux;
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "nvme" ];
  boot.kernel.sysctl = { "vm.swappiness" = 0; };
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [
    "boot.shell_on_fail"
    "pci=noats"
    "pcie_acs_override=downstream,multifunction"

    # Maybe fix NVME QID timeouts
    # https://wiki.archlinux.org/title/Solid_state_drive/NVMe#Controller_failure_due_to_broken_APST_support
    "nvme_core.default_ps_max_latency_us=5000"
  ];
  boot.kernelModules = [
    # "kvm-amd"
    # "amdgpu"
    # "vfio_virqfd"
    # "vfio_pci"
    # "vfio_iommu_type1"
    # "vfio"
    "uvcvideo"
  ];

  boot.extraModprobeConfig = ''
    options uvcvideo quirks=4
  '';

  boot.extraModulePackages = with config.boot.kernelPackages; [
    xpadneo
    zenpower
    v4l2loopback
  ];

  # nixpkgs.config.packageOverrides = pkgs: {
  #   linuxPackages_zen = pkgs.linuxPackages_zen.override {
  #     kernelPatches = pkgs.linuxPackages_zen.kernelPatches ++ [
  #       { name = "acs";
  #         patch = pkgs.fetchurl {
  #           url = "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
  #           sha256 = "5517df72ddb44f873670c75d89544461473274b2636e2299de93eb829510ea50";
  #         };
  #       }
  #     ];
  #   };
  # };

  services.xserver.videoDrivers = [ "modesetting" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/dc58aeee-ca1b-404d-aafb-a3928d6cf7c9";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1802-3D04";
    fsType = "vfat";
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/673fc3ca-f732-48b4-9b49-13c5d104f3cd";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/disk0" = {
    device = "/dev/disk/by-id/usb-HL-DT-ST_DVD+-RW_GT10N_DD56419883915-0:0";
    fsType = "auto";
    options = [ "ro" "user" "noauto" "unhide" "nofail" ];
  };

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Huge monitor stuff
  hardware.video.hidpi.enable = true;

  # Apply latest mesa in the system
  hardware.opengl.package = mesa-bleeding.drivers;
  hardware.opengl.package32 = lib32-mesa-bleeding.drivers;
  hardware.opengl.extraPackages = [ mesa-bleeding.opencl ];

  # Creates a second boot entry without latest drivers
  specialisation.stable-mesa.configuration = {
    system.nixos.tags = [ "stable-mesa" ];
    hardware.opengl.package = lib.mkForce pkgs.mesa.drivers;
    hardware.opengl.package32 = lib.mkForce pkgs.pkgsi686Linux.mesa.drivers;
  };
}
