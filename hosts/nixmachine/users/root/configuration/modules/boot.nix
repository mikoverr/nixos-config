{ ... }:
{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev"; # "nodev" is used for UEFI
        efiSupport = true;
      };

      efi.canTouchEfiVariables = true;
    };

    # Reduce page flush aggressiveness on NVMe
    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.page-cluster" = 0;
    };
  };
}
