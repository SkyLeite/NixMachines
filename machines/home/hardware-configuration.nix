{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "nvme" ];
  boot.kernel.sysctl = { "vm.swappiness" = 0; };
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [ "boot.shell_on_fail" ];
  boot.kernelModules = [ "uvcvideo" ];

  boot.extraModprobeConfig = ''
    options usbcore use_both_schemes=y
    options uvcvideo quirks=4
  '';

  boot.extraModulePackages = with config.boot.kernelPackages; [
    xpadneo
    zenpower
    v4l2loopback
  ];

  services.xserver.videoDrivers = [ "modesetting" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/71a653f5-bb05-46b1-bbe4-950652b44cf7";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D209-1E91";
    fsType = "vfat";
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/673fc3ca-f732-48b4-9b49-13c5d104f3cd";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/ram" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "nofail" "size=20G" "mode=777" "user" ];
  };

  fileSystems."/mnt/disk0" = {
    device = "/dev/disk/by-id/usb-HL-DT-ST_DVD+-RW_GT10N_DD56419883915-0:0";
    fsType = "auto";
    options = [ "ro" "user" "noauto" "unhide" "nofail" ];
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 10 * 1024;
    randomEncryption.enable = true;
  }];

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.package = pkgs.mesa.drivers;
  hardware.opengl.package32 = pkgs.pkgsi686Linux.mesa.drivers;
  hardware.opengl.extraPackages = [ 
    pkgs.mesa.opencl 
    pkgs.rocmPackages.clr.icd
    pkgs.clinfo
  ];
}
