{ ... }:
{
  users.mutableUsers = true; # allows password change via `passwd`

  users.users.admin = {
    isNormalUser = true;
    hashedPassword = "$6$...hash..."; # EDIT

    extraGroups = [ "wheel" "docker" ];

    openssh.authorizedKeys.keys = [ # EDIT
      # "ssh-ed25519 AAAA... your-key-comment"
    ];
  };

  # security.sudo.wheelNeedsPassword = false;
}
