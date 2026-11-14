{ ... }:
{
  services = {
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
  };
}
