<h1 align="center">nixos-config</h1>
<p align="center">My config helps you easily upgrade your NixOS<p>

## Content
- [Config features](#config-features)
- [Install guide](#install-guide)
- [How to modify the config](#how-to-modify-the-config)
- [Rebuild guide](#rebuild-guide)
- [I'm following the updates and I want to apply the repository changes](#im-following-the-updates-and-i-want-to-apply-the-repository-changes)

## Config features

- A comprehensive script `gonix.sh` for deploying and managing NixOS
- The configuration directory can be cloned and run from anywhere (except `/etc/nixos`)
- The script automatically creates timestamped backup folders for conflicting dotfiles (`~/.config.bkp` during rebuild and `/etc/nixos` during install)
- The configuration structure makes it easy to modify it

> [!IMPORTANT]
> Each host contains its own `DESCRIPTION.md` - be sure to take a look

## Install guide

### Scenario 1: Fresh Installation
1. Boot from the NixOS installation ISO.
2. Partition and mount your drives to `/mnt`.
3. Clone the repo and run the script:
   ```bash
   git clone https://github.com/mikoverr/nixos-config.git ~/nixos-config
   cd ~/nixos-config
   chmod +x gonix.sh
   ./gonix.sh install
   ```
4. Select your target host from the interactive menu.
5. The script will generate the hardware config, install the system, and set up the `.installed_host` file.
6. Reboot into your fully configured system.

### Scenario 2: Migration on an Existing System
1. Clone the repo to your home directory (do not place it in `/etc/nixos`).
2. Run the script:
   ```bash
   ./gonix.sh install
   ```
3. Select your target host. The script will automatically back up your current `/etc/nixos`, copy the existing hardware configuration, create a symlink, and trigger a `nixos-rebuild switch`.

> [!NOTE]
> You will be able to use the `gonix` alias after installation.

> [!NOTE]
> If you need help, type `gonix -h` or `./gonix.sh -h` in the terminal.

## How to modify the config

For each user, you can easily manage their environment by navigating to `hosts/<hostname>/users/<username>/`. You can add custom files to `assets/`, manage symlinked configurations in `dotfiles/`, and run custom setup scripts from `scripts/`. To add or remove packages and services, simply edit the corresponding `programs.nix`, `packages.nix`, and `services.nix` files. 

## Rebuild guide

After modifying the config, run the rebuild command to apply the changes.

> [!IMPORTANT]
> Type `gonix -h` or `./gonix.sh -h` in the terminal to see availble options.

Just use the command:
```bash
gonix rebuild
```

## "I'm following the updates and I want to apply the repository changes."

There are two methods...

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
> You will most likely need to resolve merge conflicts.

> [!NOTE]
> The files `.installed_host` and `hardware-configuration.nix` are not affected as they are registered in `.gitignore'.

---

<p align="center">Author: https://github.com/mikoverr</p>
