{ ... }:
{
  
  boot = {
    loader = {
        grub = {
          enable = true;
          device = "/dev/vda"; # EDIT
        };

        loader.systemd-boot.enable = false;
        loader.efi.canTouchEfiVariables = false;
    };

    # BBR for network acceleration
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
