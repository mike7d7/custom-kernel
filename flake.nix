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
          WLAN_VENDOR_ADMTEK = pkgs.lib.mkForce no;
          WLAN_VENDOR_ATMEL = pkgs.lib.mkForce no;
          WLAN_VENDOR_INTERSIL = pkgs.lib.mkForce no;
          WLAN_VENDOR_PURELIFI = pkgs.lib.mkForce no;
          WLAN_VENDOR_RSI = pkgs.lib.mkForce no;
          WLAN_VENDOR_SILABS = pkgs.lib.mkForce no;
          WLAN_VENDOR_QUANTENNA = pkgs.lib.mkForce no;

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
          F2FS_FS = pkgs.lib.mkForce no;
          XFS_FS = pkgs.lib.mkForce no;
          JFS_FS = pkgs.lib.mkForce no;
          REISERFS_FS = pkgs.lib.mkForce no;
          HFS_FS = pkgs.lib.mkForce no;
          HFSPLUS_FS = pkgs.lib.mkForce no;

          FIREWIRE = pkgs.lib.mkForce no;
          IEEE1394 = pkgs.lib.mkForce no;

          # USB optical drives
          BLK_DEV_SR = pkgs.lib.mkForce no;
          CDROM = pkgs.lib.mkForce no;

          # ISO/UDF media mounting
          ISO9660_FS = pkgs.lib.mkForce no;
          UDF_FS = pkgs.lib.mkForce no;

          # Intel-only CPU
          CPU_SUP_AMD = pkgs.lib.mkForce no;
          CPU_SUP_HYGON = pkgs.lib.mkForce no;
          CPU_SUP_CENTAUR = pkgs.lib.mkForce no;
          CPU_SUP_ZHAOXIN = pkgs.lib.mkForce no;
          KVM_AMD = pkgs.lib.mkForce no;
          AMD_PMC = pkgs.lib.mkForce no;
          AMD_PMF = pkgs.lib.mkForce no;
          SENSORS_K10TEMP = pkgs.lib.mkForce no;
          SENSORS_AMD_ENERGY = pkgs.lib.mkForce no;
          EDAC_AMD64 = pkgs.lib.mkForce no;
          X86_AMD_PLATFORM_DEVICE = pkgs.lib.mkForce no;
          PINCTRL_AMD = pkgs.lib.mkForce no;

          # virtio/hypervisor GUEST drivers
          VIRTIO_PCI = pkgs.lib.mkForce no;
          VIRTIO_NET = pkgs.lib.mkForce no;
          VIRTIO_BLK = pkgs.lib.mkForce no;
          VIRTIO_CONSOLE = pkgs.lib.mkForce no;
          VIRTIO_BALLOON = pkgs.lib.mkForce no;
          VIRTIO_INPUT = pkgs.lib.mkForce no;
          VIRTIO_MMIO = pkgs.lib.mkForce no;
          VMWARE_BALLOON = pkgs.lib.mkForce no;
          # Keep: KVM_INTEL, TUN, BRIDGE, VHOST_NET

          # Bluetooth: keep USB HCI + Intel
          BT_HCIUART = pkgs.lib.mkForce no;
          BT_HCIBCM203X = pkgs.lib.mkForce no;
          BT_HCIBPA10X = pkgs.lib.mkForce no;
          BT_HCIBFUSB = pkgs.lib.mkForce no;
          BT_HCIVHCI = pkgs.lib.mkForce no;
          BT_HCIDTL1 = pkgs.lib.mkForce no;
          BT_HCIBT3C = pkgs.lib.mkForce no;
          BT_HCIBLUECARD = pkgs.lib.mkForce no;
          BT_HCIBTSDIO = pkgs.lib.mkForce no;
          BT_ATH3K = pkgs.lib.mkForce no;
          BT_MRVL = pkgs.lib.mkForce no;
          BT_MRVL_SDIO = pkgs.lib.mkForce no;
          # Keep: BT_HCIBTUSB, BT_INTEL

          # Wired ethernet
          NET_VENDOR_3COM = pkgs.lib.mkForce no;
          NET_VENDOR_ADAPTEC = pkgs.lib.mkForce no;
          NET_VENDOR_AGERE = pkgs.lib.mkForce no;
          NET_VENDOR_ALACRITECH = pkgs.lib.mkForce no;
          NET_VENDOR_ALIBABA = pkgs.lib.mkForce no;
          NET_VENDOR_AMAZON = pkgs.lib.mkForce no;
          NET_VENDOR_AMD = pkgs.lib.mkForce no;
          NET_VENDOR_AQUANTIA = pkgs.lib.mkForce no;
          NET_VENDOR_ARC = pkgs.lib.mkForce no;
          NET_VENDOR_ASIX = pkgs.lib.mkForce no;
          NET_VENDOR_ATHEROS = pkgs.lib.mkForce no;
          NET_VENDOR_BROADCOM = pkgs.lib.mkForce no;
          NET_VENDOR_CADENCE = pkgs.lib.mkForce no;
          NET_VENDOR_CAVIUM = pkgs.lib.mkForce no;
          NET_VENDOR_CHELSIO = pkgs.lib.mkForce no;
          NET_VENDOR_CISCO = pkgs.lib.mkForce no;
          NET_VENDOR_CORTINA = pkgs.lib.mkForce no;
          NET_VENDOR_DAVICOM = pkgs.lib.mkForce no;
          NET_VENDOR_DEC = pkgs.lib.mkForce no;
          NET_VENDOR_DLINK = pkgs.lib.mkForce no;
          NET_VENDOR_EMULEX = pkgs.lib.mkForce no;
          NET_VENDOR_ENGLEDER = pkgs.lib.mkForce no;
          NET_VENDOR_EZCHIP = pkgs.lib.mkForce no;
          NET_VENDOR_FUNGIBLE = pkgs.lib.mkForce no;
          NET_VENDOR_GOOGLE = pkgs.lib.mkForce no;
          NET_VENDOR_HISILICON = pkgs.lib.mkForce no;
          NET_VENDOR_HUAWEI = pkgs.lib.mkForce no;
          NET_VENDOR_I825XX = pkgs.lib.mkForce no;
          NET_VENDOR_INTEL = pkgs.lib.mkForce no;
          NET_VENDOR_ADI = pkgs.lib.mkForce no;
          NET_VENDOR_LITEX = pkgs.lib.mkForce no;
          NET_VENDOR_MARVELL = pkgs.lib.mkForce no;
          NET_VENDOR_MELLANOX = pkgs.lib.mkForce no;
          NET_VENDOR_META = pkgs.lib.mkForce no;
          NET_VENDOR_MICREL = pkgs.lib.mkForce no;
          NET_VENDOR_MICROCHIP = pkgs.lib.mkForce no;
          NET_VENDOR_MICROSEMI = pkgs.lib.mkForce no;
          NET_VENDOR_MICROSOFT = pkgs.lib.mkForce no;
          NET_VENDOR_MUCSE = pkgs.lib.mkForce no;
          NET_VENDOR_MYRI = pkgs.lib.mkForce no;
          NET_VENDOR_NI = pkgs.lib.mkForce no;
          NET_VENDOR_NATSEMI = pkgs.lib.mkForce no;
          NET_VENDOR_NETRONOME = pkgs.lib.mkForce no;
          NET_VENDOR_8390 = pkgs.lib.mkForce no;
          NET_VENDOR_NVIDIA = pkgs.lib.mkForce no;
          NET_VENDOR_OKI = pkgs.lib.mkForce no;
          NET_VENDOR_PENSANDO = pkgs.lib.mkForce no;
          NET_VENDOR_QLOGIC = pkgs.lib.mkForce no;
          NET_VENDOR_BROCADE = pkgs.lib.mkForce no;
          NET_VENDOR_QUALCOMM = pkgs.lib.mkForce no;
          NET_VENDOR_RDC = pkgs.lib.mkForce no;
          NET_VENDOR_REALTEK = pkgs.lib.mkForce no;
          NET_VENDOR_RENESAS = pkgs.lib.mkForce no;
          NET_VENDOR_ROCKER = pkgs.lib.mkForce no;
          NET_VENDOR_SAMSUNG = pkgs.lib.mkForce no;
          NET_VENDOR_SEEQ = pkgs.lib.mkForce no;
          NET_VENDOR_SILAN = pkgs.lib.mkForce no;
          NET_VENDOR_SIS = pkgs.lib.mkForce no;
          NET_VENDOR_SOLARFLARE = pkgs.lib.mkForce no;
          NET_VENDOR_SMSC = pkgs.lib.mkForce no;
          NET_VENDOR_SOCIONEXT = pkgs.lib.mkForce no;
          NET_VENDOR_STMICRO = pkgs.lib.mkForce no;
          NET_VENDOR_SUN = pkgs.lib.mkForce no;
          NET_VENDOR_SYNOPSYS = pkgs.lib.mkForce no;
          NET_VENDOR_TEHUTI = pkgs.lib.mkForce no;
          NET_VENDOR_TI = pkgs.lib.mkForce no;
          NET_VENDOR_VERTEXCOM = pkgs.lib.mkForce no;
          NET_VENDOR_VIA = pkgs.lib.mkForce no;
          NET_VENDOR_WANGXUN = pkgs.lib.mkForce no;
          NET_VENDOR_WIZNET = pkgs.lib.mkForce no;
          NET_VENDOR_XILINX = pkgs.lib.mkForce no;

          # LUKS Crypto ciphers
          CRYPTO_TWOFISH = pkgs.lib.mkForce no;
          # CRYPTO_SERPENT = pkgs.lib.mkForce no;
          CRYPTO_BLOWFISH = pkgs.lib.mkForce no;
          # CRYPTO_CAST5 = pkgs.lib.mkForce no;
          # CRYPTO_CAST6 = pkgs.lib.mkForce no;
          # CRYPTO_CAMELLIA = pkgs.lib.mkForce no;
          CRYPTO_ANUBIS = pkgs.lib.mkForce no;
          CRYPTO_KHAZAD = pkgs.lib.mkForce no;
          CRYPTO_SEED = pkgs.lib.mkForce no;
          CRYPTO_FCRYPT = pkgs.lib.mkForce no;
          CRYPTO_TEA = pkgs.lib.mkForce no;

          # Single-socket CPU
          NUMA = pkgs.lib.mkForce no;

          # Exotic ABIs
          X86_X32_ABI = pkgs.lib.mkForce no;

          # No ECC RAM on my laptop
          EDAC = pkgs.lib.mkForce no;

          # Custom stuff
          NTSYNC = yes;
          V4L2_LOOPBACK = yes;
        };
      };
    in
      (pkgs.linuxKernel.packagesFor kernelSet).kernel;
  };
}
