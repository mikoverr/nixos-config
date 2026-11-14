<h1 align="center">NixOS Config</h1>
<p align="center">My config helps you easily upgrade and maintain your NixOS setup<p>

## Content

- [Config features](#config-features)
- [Install guide](#install-guide)
- [How to modify the config](#how-to-modify-the-config)
- [Rebuild guide](#rebuild-guide)
- [Applying Repository Updates](#applying-repository-updates)

## Config features

- `gonix.sh` - A comprehensive script for deploying and managing NixOS systems
- Portable configuration directory (can be cloned from anywhere except `/etc/nixos`)
- Automatic timestamped backups of conflicting dotfiles (`~/.config.bkp` during rebuild, `/etc/nixos` during install)
- Clear separation of concerns making modifications straightforward

> [!IMPORTANT]  
> Each host contains its own `DESCRIPTION.md` — please review it for host-specific configurations.

## Install guide

### Scenario 1: Fresh Installation

```bash
# Boot from NixOS installation ISO
# Partition and mount your drives to /mnt
git clone https://github.com/mikoverr/nixos-config.git ~/nixos-config
cd ~/nixos-config
chmod +x gonix.sh
./gonix.sh install
```

1. Select your target host from the interactive menu
2. The script will generate hardware config, install system, and create `.installed_host` file
3. Reboot into your fully configured system

### Scenario 2: Migration on an Existing System

```bash
# Clone repo to home directory (NOT /etc/nixos)
git clone https://github.com/mikoverr/nixos-config.git ~/nixos-config
cd ~/nixos-config
chmod +x gonix.sh
./gonix.sh install
```

1. Select your target host
2. Script automatically backs up `/etc/nixos`, copies hardware config, creates symlinks, and triggers `nixos-rebuild switch`

> [!NOTE]  
> After installation, use the `gonix` alias for quick access to commands.  
> For help: type `gonix -h` or `./gonix.sh -h` in your terminal.

## How to modify the config

For each user, navigate to `hosts/<hostname>/users/<username>/`. You can:
- Add custom files to `assets/`
- Manage symlinked configurations in `dotfiles/`
- Run custom setup scripts from `scripts/`
- Edit `programs.nix`, `packages.nix`, and `services.nix` for package/service management

## Rebuild Guide

After modifying the config, apply changes with:

```bash
gonix rebuild
```

> [!IMPORTANT]  
> Type `gonix -h` or `./gonix.sh -h` to view all available commands.

## Applying Repository Updates

### Method 1: Using a local branch (Recommended)

```bash
git checkout -b my-local-config
# then switch to the main branch
git fetch origin
git rebase origin/main my-local-config
```

### Method 2: Using `git pull --rebase` (Quick way)

```bash
git add .
git commit -m "My local changes"
git pull --rebase origin main
```

> [!WARNING]
> You will likely need to resolve merge conflicts.

> [!NOTE]
> Files `.installed_host` and `hardware-configuration.nix` are NOT affected (they're in `.gitignore`)

---

<p align="center">Author: https://github.com/mikoverr</p>
