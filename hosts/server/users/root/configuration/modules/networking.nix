{ ... }:
{
  networking = {
    hostName = "server";

    useDHCP = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [
        # 22 # SSH (already allowed with openssh service)
        80 # HTTP (Caddy, Lets Encrypt)
        443 # HTTPS

        # 2053 # 3x-ui
      ];
      allowedUDPPorts = [
        # 443
        # 20000:50000 # port hopping Hysteria2
      ];
    };

    networkmanager.enable = true;
  };
}
