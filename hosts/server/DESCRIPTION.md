<h1 align="center">fack-vps host description</h1>

## Host purpose

This is the configuration for my servers. I mostly use Docker for different projects that need to be on servers.

## What to do before installation

Before deploying, edit the following files in `hosts/server/`:

### 1. User Access (`users/root/configuration/modules/users.nix`)
*   **SSH Key:** Add your public key (`id_ed25519.pub`) to the `admin` user's `authorizedKeys.keys`.
*   **Password:** Generate a hash via `mkpasswd -m sha-512` and set it as `hashedPassword` for the `admin` user (required for `sudo`).
*   **Root Access:** Direct SSH login as `root` is disabled. You must log in as `admin` and use `sudo`.

### 2. Network Configuration (`users/root/configuration/modules/networking.nix`)
*   **Interface:** Change `iface` to your network interface name (find it with `ip a`, e.g., `eth0`, `ens3`, `enp1s0`).
*   **Static IP (Default):** Fill in `address`, `prefixLength`, and `via` (gateway) according to your VPS provider's details. Also, set your preferred `nameservers`.
*   **DHCP:** If your VPS provider automatically assigns IPs, comment out the `interfaces` block and uncomment `useDHCP = true;`.
