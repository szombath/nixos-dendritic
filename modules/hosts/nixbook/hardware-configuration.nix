{ inputs, ... }:
{
  configurations.nixos.nixbook.module =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    {
      imports = [ 
        (modulesPath + "/profiles/qemu-guest.nix")

        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];

      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [ ];

        initrd = {
          availableKernelModules = [ 
            "ahci" 
            "sr_mod" 
            "virtio_blk"
            "virtio_pci" 
            "xhci_pci" 
          ];
        };
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/94f3d2b0-cd29-40e6-a675-a0083cf72640";
        fsType = "ext4";
      };
      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/3264-E4DE";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };

      swapDevices = [ { device = "/dev/disk/by-uuid/30f1073d-6709-44d5-91be-cfd0ecd581a9"; } ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
