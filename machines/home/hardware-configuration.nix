# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernel.sysctl = { "vm.swappiness" = 0; };
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [
    "boot.shell_on_fail"
    "pci=noats"
    "pcie_acs_override=downstream,multifunction"
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

  boot.extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];

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

  # services.xserver.videoDrivers = ["amdgpu"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5dac99e1-1850-4b49-8154-0739a1f22716";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8A7A-9713";
    fsType = "vfat";
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/673fc3ca-f732-48b4-9b49-13c5d104f3cd";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  swapDevices = [ ];

}
