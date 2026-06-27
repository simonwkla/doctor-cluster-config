{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/hardware/supermicro-322GA-NR.nix
    ../modules/nfs/client.nix
    ../modules/nfs
    ../modules/nvidia.nix
    ../modules/intel_tdx.nix
    ../modules/vfio/iommu-intel.nix
  ];

  disko.rootDisk = "/dev/disk/by-id/nvme-SAMSUNG_MZQL23T8HCLS-00A07_S64HNN0XA09313";

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  networking.hostName = "steve";
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-intel" ];

  system.stateVersion = "22.11";

  systemd.timers.auto-reboot.enable = false;
  systemd.services.auto-reboot.enable = false;
  systemd.services.auto-upgrade.enable = false;

  boot.extraModulePackages = [ config.boot.kernelPackages.mlnx_ofed ];
}
