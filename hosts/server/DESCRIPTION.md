<h1 align="center">fack-vps host description</h1>

## Host purpose

This is the configuration for my servers. I mostly use Docker for different projects that need to be on servers.

## What to do before installation

Before deploying, edit `hosts/server/users/root/configuration/modules/users.nix`:

1. **SSH Key:** Add your public key (`id_ed25519.pub`) to the `admin` user's `authorizedKeys.keys`.
2. **Password:** Generate a hash via `mkpasswd -m sha-512` and set it as `hashedPassword` for the `admin` user (required for `sudo`).
3. **Root Access:** Direct SSH login as `root` is disabled. Log in as `admin` and use `sudo`.
