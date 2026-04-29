{
  description = "Custom kernel for nixos";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-cachyos-kernel,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default =
        let
          kernel = pkgs.cachyosKernels.linux-cachyos-latest.override {
            # Customize CachyOS settings
            cpusched = "eevdf";
            lto = "full";
            processorOpt = "x86_64-v3";
            hzTicks = "1000";
            bbr3 = true;
            hardened = false;
            autofdo = true;
            autoModules = false;
            # Additional args are available. See kernel-cachyos/mkCachyKernel.nix
            structuredExtraConfig = {
              CONFIG_DEBUG_INFO = "n";
              CONFIG_DEBUG_KERNEL = "n";
              CONFIG_DEBUG_ATOMIC_SLEEP = "n";
              CONFIG_DEBUG_SPINLOCK = "n";
              CONFIG_DEBUG_MUTEXES = "n";
              CONFIG_DEBUG_RT_MUTEXES = "n";
              CONFIG_DEBUG_SLAB = "n";
            };
          };
          # helpers.nix provides a few utilities for building kernel with LTO.
          # I haven't figured out a clean way to expose it in flakes.
          helpers = pkgs.callPackage "${nix-cachyos-kernel.outPath}/helpers.nix" { };
        in
        helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);
    };
}
