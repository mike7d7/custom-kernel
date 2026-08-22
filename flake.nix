{
  description = "CachyOS kernel flake for NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };
  outputs = {
    self,
    nixpkgs,
    nix-cachyos-kernel,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        nix-cachyos-kernel.overlays.pinned
      ];
    };
  in {
    packages.${system}.default = let
      kernelSet = pkgs.cachyosKernels.linux-cachyos-latest.override {
        cpusched = "eevdf";
        lto = "full";
        processorOpt = "x86_64-v3";
        hzTicks = "1000";
        bbr3 = true;
        hardened = false;
        autofdo = true;
        autoModules = false;

        structuredExtraConfig = with pkgs.lib.kernel; {
          DRM_AMDGPU = no;
          DRM_RADEON = no;
          DRM_NOUVEAU = no;

          # Virtual/VM-only display drivers
          DRM_VMWGFX = no;
          DRM_VIRTIO_GPU = no;
          DRM_QXL = no;
          DRM_BOCHS = no;
          DRM_CIRRUS_QEMU = no;

          # ALSA SoC framework
          SND_SOC = no;

          # Entire staging driver tree
          STAGING = pkgs.lib.mkForce no;

          # V4L2 media subsystem
          MEDIA_SUPPORT = yes;
          VIDEO_DEV = yes;
          MEDIA_CAMERA_SUPPORT = yes; # webcam drivers
          MEDIA_ANALOG_TV_SUPPORT = pkgs.lib.mkForce no;
          MEDIA_DIGITAL_TV_SUPPORT = pkgs.lib.mkForce no;
          MEDIA_RADIO_SUPPORT = no;
          MEDIA_SDR_SUPPORT = no;
          MEDIA_CEC_SUPPORT = no;
          MEDIA_PCI_SUPPORT = pkgs.lib.mkForce no;
          MEDIA_USB_SUPPORT = yes;
          MEDIA_PLATFORM_SUPPORT = no;
          DVB_CORE = no;
          VIDEO_V4L2_SUBDEV_API = no;

          # Enterprise networking
          INFINIBAND = pkgs.lib.mkForce no;

          # Wireless drivers
          ATH9K = pkgs.lib.mkForce no;
          ATH10K = pkgs.lib.mkForce no;
          ATH11K = pkgs.lib.mkForce no;
          RTL8XXXU = pkgs.lib.mkForce no;
          RTLWIFI = pkgs.lib.mkForce no;
          RTW88 = pkgs.lib.mkForce no;
          RTW89 = pkgs.lib.mkForce no;
          BRCMFMAC = pkgs.lib.mkForce no;
          BRCMSMAC = pkgs.lib.mkForce no;
          MT76_CORE = pkgs.lib.mkForce no;
          WLAN_VENDOR_ATH = pkgs.lib.mkForce no;
          WLAN_VENDOR_BROADCOM = pkgs.lib.mkForce no;
          WLAN_VENDOR_MEDIATEK = pkgs.lib.mkForce no;
          WLAN_VENDOR_REALTEK = pkgs.lib.mkForce no;
          WLAN_VENDOR_RALINK = pkgs.lib.mkForce no;
          WLAN_VENDOR_MARVELL = pkgs.lib.mkForce no;
          WLAN_VENDOR_TI = pkgs.lib.mkForce no;
          WLAN_VENDOR_ZYDAS = pkgs.lib.mkForce no;
          WLAN_VENDOR_MICROCHIP = pkgs.lib.mkForce no;
          WLAN_VENDOR_ST = pkgs.lib.mkForce no;

          # Legacy/unused bus & hardware support
          PARPORT = pkgs.lib.mkForce no;
          PCMCIA = pkgs.lib.mkForce no;
          ISA_BUS = pkgs.lib.mkForce no;
          FLOPPY = pkgs.lib.mkForce no;

          # PATA
          ATA_SFF = pkgs.lib.mkForce no;
          ATA = pkgs.lib.mkForce no;

          # Legacy sound drivers
          SND_ISA = pkgs.lib.mkForce no;
          SND_PCI = pkgs.lib.mkForce no;

          # Network filesystems
          NFSD = pkgs.lib.mkForce no; # NFS server
          CEPH_FS = pkgs.lib.mkForce no;
          AFS_FS = pkgs.lib.mkForce no;
          ORANGEFS_FS = pkgs.lib.mkForce no;
          CODA_FS = pkgs.lib.mkForce no;
          # 9P_FS = pkgs.lib.mkForce no;

          # Kernel debug
          DEBUG_INFO_NONE = pkgs.lib.mkForce yes;
          DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT = pkgs.lib.mkForce no;
          DEBUG_INFO_DWARF4 = pkgs.lib.mkForce no;
          DEBUG_INFO_DWARF5 = pkgs.lib.mkForce no;
          DEBUG_INFO_REDUCED = pkgs.lib.mkForce no;
          DEBUG_INFO_BTF = pkgs.lib.mkForce no;
          DEBUG_INFO_BTF_MODULES = pkgs.lib.mkForce no;
          FTRACE = pkgs.lib.mkForce no;
          KGDB = pkgs.lib.mkForce no;

          # RAID
          MD_RAID0 = pkgs.lib.mkForce no;
          MD_RAID1 = pkgs.lib.mkForce no;
          MD_RAID10 = pkgs.lib.mkForce no;
          MD_RAID456 = pkgs.lib.mkForce no;

          # Hypervisor guest drivers
          XEN = pkgs.lib.mkForce no;
          HYPERV = pkgs.lib.mkForce no;

          DRM_I915_DEBUG = pkgs.lib.mkForce no;
          DRM_I915_DEBUG_GEM = pkgs.lib.mkForce no;
          DRM_I915_SELFTEST = pkgs.lib.mkForce no;
          DRM_I915_LOW_LEVEL_TRACEPOINTS = pkgs.lib.mkForce no;

          # Kernel self-test framework, only needed for kernel development
          KUNIT = pkgs.lib.mkForce no;

          SCSI_LOWLEVEL = pkgs.lib.mkForce no;

          # Filesystems
          MINIX_FS = pkgs.lib.mkForce no;
          SYSV_FS = pkgs.lib.mkForce no;
          UFS_FS = pkgs.lib.mkForce no;
          BEFS_FS = pkgs.lib.mkForce no;
          BFS_FS = pkgs.lib.mkForce no;
          EFS_FS = pkgs.lib.mkForce no;
          JFFS2_FS = pkgs.lib.mkForce no;
          QNX4FS_FS = pkgs.lib.mkForce no;
          QNX6FS_FS = pkgs.lib.mkForce no;
          HPFS_FS = pkgs.lib.mkForce no;
          NILFS2_FS = pkgs.lib.mkForce no;

          FIREWIRE = pkgs.lib.mkForce no;
          IEEE1394 = pkgs.lib.mkForce no;

          # USB optical drives
          BLK_DEV_SR = pkgs.lib.mkForce no;
          CDROM = pkgs.lib.mkForce no;

          # ISO/UDF media mounting
          ISO9660_FS = pkgs.lib.mkForce no;
          UDF_FS = pkgs.lib.mkForce no;
        };
      };
    in
      (pkgs.linuxKernel.packagesFor kernelSet).kernel;
  };
}
