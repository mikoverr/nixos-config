{ ... }:
let
  iface = "enp1s0"; # EDIT / find out with the command `ip a`
in
{
  networking = {
    hostName = "server";

    # Use systemd-networkd
    useNetworkd = true;

    interfaces.${iface} = {
      ipv4.addresses = [{
        address = "192.0.2.10"; # EDIT/ your static ip / contact your hoster
        prefixLength = 24; # EDIT / mask (24 = 255.255.255.0) / contact your hoster
      }];
      ipv4.routes = [{
        address = "0.0.0.0";
        prefixLength = 0;
        via = "192.0.2.1"; # EDIT / contact your hoster
      }];
    };

    # EDIT / DNS (contact your hoster or use public ones, for example, 1.1.1.1 or 8.8.8.8)
    nameservers = [ 
      "8.8.8.8" 
      "1.1.1.1"
    ];

    # If you don't need to set up a static ip and dns, then just use:
    # useDHCP = true;

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
  };
}
