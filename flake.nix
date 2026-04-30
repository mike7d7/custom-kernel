{
  description = "CachyOS kernel flake for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-cachyos-kernel,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nix-cachyos-kernel.overlays.pinned
        ];
      };
    in
    {
      packages.${system}.default =
        let
          kernelSet = pkgs.cachyosKernels.linux-cachyos-latest.override {
            cpusched = "eevdf";
            lto = "full";
            processorOpt = "x86_64-v3";
            hzTicks = "1000";
            bbr3 = true;
            hardened = false;
            autofdo = true;
            autoModules = false;
          };
        in
        (pkgs.linuxKernel.packagesFor kernelSet).kernel;

      overlays.pinned = final: prev: {
        cachyosKernels = pkgs.cachyosKernels;
      };
    };
}
