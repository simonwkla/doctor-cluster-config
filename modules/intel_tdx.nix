{ pkgs, lib, ... }:
{
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  boot.zfs.package = pkgs.zfs_unstable; # needed for 6.18

  boot.kernelPatches = [
    {
      name = "tdx-config";
      patch = null;
      # TDX now supports kexec as of kernel 6.18 (commit 80804847269e)
      structuredExtraConfig = with lib.kernel; {
        KVM = yes;
        KVM_INTEL = yes;
        KVM_INTEL_TDX = yes;

        X86_X2APIC = yes;
        X86_MCE = yes;
        INTEL_TDX_HOST = yes;
      };
    }
  ];

  boot.kernelParams = [
    "kvm_intel.tdx=1"
    # TDX cannot survive from S3 and deeper states
    "nohibernate"
    "acpi=nos3"
  ];

  virtualisation.libvirtd.enable = true;
}
