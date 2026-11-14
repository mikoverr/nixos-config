{ ... }:
{
  services = {
    resolved.enable = true;

    logrotate.enable = true;

    qemuGuest.enable = true; # to communicate with the hypervisor on the hoster's side

    journald.storage = "persistent"; # store logs after reboot

    openssh = {
      enable = true;
      openFirewall = true; # auto open port 22
      settings = {
        PermitRootLogin = "no"; # no direct root login
        PasswordAuthentication = false; # only SSH keys
        KbdInteractiveAuthentication = false;
      };
    };

    fail2ban.enable = true;

    systemd.network.wait-online.enable = false;
  };
}
